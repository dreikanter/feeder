class PullJob < ApplicationJob
  queue_as :default

  def perform(feed_name)
    started_at = Time.zone.now

    posts = Service::FeedLoader.load(feed_name)
    posts.each { |p| PushJob.perform_later p }

    DataPoint.create_pull(
      posts_count: posts.count,
      feed_name: feed_name,
      duration: Time.zone.now - started_at
    )
  end
end
