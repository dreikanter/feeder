class PullJob < ApplicationJob
  queue_as :default

  rescue_from StandardError do |e|
    logger.error '---> error loading the feed'
    logger.error e.message

    DataPoint.create_pull(
      feed_name: self.arguments.first,
      status: 'error'
    )
  end


  def perform(feed_name)
    started_at = Time.zone.now
    posts_count = 0
    feed = Feed.find_by_name(feed_name)

    Service::FeedLoader.load(feed_name).each do |entity|
      begin
        logger.info '---> creating new post'
        PushJob.perform_later(Post.create!(entity.merge(
          feed: feed,
          status: Enums::PostStatus.ready)
        ))

        posts_count += 1
      rescue => e
        logger.error "---> error processing feed entity: #{e.message}"
      end
    end

    DataPoint.create_pull(
      posts_count: posts_count,
      feed_name: feed_name,
      duration: Time.zone.now - started_at,
      status: 'success'
    )
  end
end
