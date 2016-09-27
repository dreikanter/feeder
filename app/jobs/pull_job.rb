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
    feed = Feed.find_by_name(feed_name)

    Service::FeedLoader.load(feed_name).each do |entity|
      begin
        logger.info '---> creating new post'
        Post.create!(entity.merge(
          feed: feed,
          status: Enums::PostStatus.ready)
        )
      rescue => e
        logger.error "---> error processing feed entity: #{e.message}"
      end
    end

    posts = Post.publishing_queue.where(feed: feed)
    posts_count = posts.each { |post| PushJob.perform_later(post) }.count

    DataPoint.create_pull(
      posts_count: posts_count,
      feed_name: feed_name,
      duration: Time.zone.now - started_at,
      status: 'success'
    )
  end
end
