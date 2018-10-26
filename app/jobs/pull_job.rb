class PullJob < ApplicationJob
  queue_as :default

  def perform(feed_name)
    started_at = Time.now.utc

    feed = Feed.for(feed_name)
    raise 'feed not found' unless feed

    logger.info "---> loading feed: #{feed.name}"

    posts_count = 0
    errors_count = 0

    normalizer = Service::NormalizerResolver.for(feed_name)
    logger.info "---> normalizer: #{normalizer}"

    load_entities(feed).each do |link, entity|
      begin
        logger.info "---> processing next entity #{'-' * 50}"
        if Post.exists?(feed: feed, link: link)
          logger.debug "---> already exists; skipping"
          next
        end

        # Skip unprocessable entities
        post_attributes = normalizer.process(entity)
        unless post_attributes
          logger.debug "---> normalization error; skipping"
          next
        end

        # Skip stale entities
        published_at = post_attributes['published_at']
        time_constraint = !!(feed.after && published_at)
        unless !time_constraint || (published_at > feed.after)
          logger.debug "---> stale post; skipping"
          next
        end

        logger.info '---> creating new post'
        commons = { feed_id: feed.id, status: Enums::PostStatus.ready }
        Post.create!(**post_attributes.merge(commons))
        posts_count += 1
      rescue => exception
        logger.error "---> error processing entity: #{exception.message}"
        errors_count += 1
        Error.dump(exception, context: {
          class_name: self.class.name,
          feed_name: feed_name,
          hint: 'error processing entity'
        })
      end
    end

    Post.publishing_queue_for(feed).each { |p| PushJob.perform_later(p) }

    DataPoint.create_pull(
      feed_name: feed_name,
      posts_count: posts_count,
      errors_count: errors_count,
      duration: Time.new.utc - started_at,
      status: 'success'
    )

    DataPoint.purge_old_records!
  end

  private

  def load_entities(feed)
    Service::FeedLoader.call(feed)
  rescue => exception
    logger.error "---> error loading feed: #{exception.message}"
    Error.dump(exception, context: {
      class_name: self.class.name,
      feed_name: feed.name,
      hint: 'error loading feed'
    })
    []
  end
end
