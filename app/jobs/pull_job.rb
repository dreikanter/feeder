class PullJob < ApplicationJob
  queue_as :default

  rescue_from StandardError do |e|
    logger.error '---> error loading feed'
    logger.error e.message

    DataPoint.create_pull(
      feed_name: self.arguments.first,
      message: e.message,
      status: 'error'
    )
  end

  def perform(feed_name)
    started_at = Time.zone.now

    feed = Feed.find_or_import(feed_name)
    raise 'feed not found' unless feed

    logger.info "---> loading feed: #{feed.name}"

    posts_count = 0
    errors_count = 0

    normalizer = Service::FeedNormalizer.for(feed)
    logger.info "---> normalizer: #{normalizer.entity_normalizer}"

    Service::FeedLoader.load(feed_name).each do |link, entity|
      begin
        logger.info "---> processing next entity #{'-' * 50}"
        next if Post.exists?(feed: feed, link: link)
        logger.info '---> creating new post'
        Post.create!(normalizer.process(entity))
        posts_count += 1
      rescue => e
        logger.error "---> error processing entity: #{e.message}"
        errors_count += 1
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
end
