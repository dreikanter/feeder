class PullJob < ApplicationJob
  queue_as :default

  rescue_from StandardError do |exception|
    Rails.logger.error("---> error processing feed: #{exception.message}")
    feed_name = arguments[0]
    Service::FeedsRepository.call(feed_name).update(refreshed_at: nil)
    Error.dump(exception, context: {
      class_name: self.class.name,
      feed_name: feed_name,
      hint: 'error processing feed'
    })
  end

  def perform(feed_name)
    started_at = Time.now.utc

    logger.info "---> loading feed: #{feed_name}"
    feed = Service::FeedsRepository.call(feed_name)

    normalizer = Service::NormalizerResolver.call(feed_name)
    logger.info "---> normalizer: #{normalizer}"

    feed.update(refreshed_at: started_at)
    processor = Service::ProcessorResolver.call(feed)
    content = Service::FeedLoader.call(feed)
    entities = processor.call(content)

    posts_count = 0
    errors_count = 0

    entities.each do |link, entity|
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
end
