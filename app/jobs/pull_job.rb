class PullJob < ApplicationJob
  queue_as :default

  rescue_from StandardError do |exception|
    Rails.logger.error("---> error processing feed: #{exception.message}")
    feed_name = arguments[0]
    Service::FeedFinder.call(feed_name).update(refreshed_at: nil)
    Error.dump(exception, context: {
      class_name: self.class.name,
      feed_name: feed_name,
      hint: 'error processing feed'
    })
  end

  def perform(feed_name)
    started_at = Time.now.utc
    feed = Service::FeedFinder.call(feed_name)

    unless feed.refresh?
      logger.info "---> skipping feed: #{feed_name}"
      logger.debug "---> refresh interval: #{feed.refresh_interval}"
      logger.debug "---> refreshed at: #{feed.refreshed_at}"
      return
    end

    logger.info "---> loading feed: #{feed_name}"
    feed.update(refreshed_at: started_at)

    processor = Service::ProcessorResolver.call(feed)
    logger.info "---> processor: #{processor}"

    content = Service::FeedLoader.call(feed)
    entities = processor.call(content)

    normalizer = Service::NormalizerResolver.call(feed)
    logger.info "---> normalizer: #{normalizer}"

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
        normalized = normalizer.call(entity)
        payload = normalized.payload

        if normalized.failure?
          logger.debug "---> entity rejected: #{payload}"
          next
        end

        # Skip stale entities
        published_at = payload['published_at']
        after = feed.after

        unless !after || !published_at || (published_at > after)
          logger.debug "---> stale post; skipping"
          next
        end

        logger.info '---> creating new post'
        Post.create!(payload.merge(
          'feed_id' => feed.id,
          'status' => Enums::PostStatus.ready
        ))

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
