class PullJob < ApplicationJob
  queue_as :default

  rescue_from StandardError do |e|
    logger.error 'error loading the feed'
    logger.error e.message

    DataPoint.create_pull(
      feed_name: feed_name,
      status: 'error'
    )
  end


  def perform(feed_name)
    started_at = Time.zone.now

    Service::FeedLoader.load(feed_name)

    posts = Post.where(feed: Feed.find_by_name(feed_name), status: :ready)

    DataPoint.create_pull(
      posts_count: posts.count,
      feed_name: feed_name,
      duration: Time.zone.now - started_at,
      status: 'success'
    )

    posts.each { |p| PushJob.perform_later p }
  end
end
