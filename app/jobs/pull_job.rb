class PullJob < ApplicationJob
  queue_as :default

  def perform(feed_name)
    started_at = Time.zone.now

    feed = Feed.for(feed_name)
    raise 'feed not found' unless feed

    logger.info "---> loading feed: #{feed.name}"

    posts_count = 0
    errors_count = 0

    normalizer = Service::FeedNormalizer.for(feed)
    logger.info "---> normalizer: #{normalizer.entity_normalizer}"

    load_entities(feed_name).each do |link, entity|
      begin
        logger.info "---> processing next entity #{'-' * 50}"
        next if Post.exists?(feed: feed, link: link)

        post_attributes = normalizer.process(entity)
        next unless post_attributes

        logger.info '---> creating new post'
        Post.create!(post_attributes)
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
      duration: Time.zone.now - started_at,
      status: 'success'
    )

    DataPoint.purge_old_records!
  end

  private

  def load_entities(feed_name)
    Service::FeedLoader.load(feed_name)
  rescue => exception
    logger.error "---> error loading feed: #{exception.message}"
    Error.dump(exception, context: {
      class_name: self.class.name,
      feed_name: feed_name,
      hint: 'error loading feed'
    })
    []
  end
end
