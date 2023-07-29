# Imports new posts with `PostsImporter` and publishes enqueued posts with `PostPublisher`
class FeedProcessor
  attr_reader :feed

  def initialize(feed)
    @feed = feed
  end

  def process
    feed.touch(:refreshed_at)
    import_new_posts
    publish_enqueued_posts
  end

  private

  def import_new_posts
    PostsImporter.new(feed).import
    reset_errors_count
  rescue StandardError => e
    Honeybadger.notify(e)
    increment_feed_error_counters
  end

  def publish_enqueued_posts
    publication_queue.each { PostPublisher.new(_1).publish }
    feed.update_sparkline
  end

  def publication_queue
    Post.where(feed: feed).enqueued.order(published_at: :asc).limit(import_limit_or_default)
  end

  def increment_feed_error_counters
    feed.update!(
      errors_count: feed.errors_count.succ,
      total_errors_count: feed.total_errors_count.succ
    )
  end

  def reset_errors_count
    feed.update!(errors_count: 0)
  end

  delegate :import_limit_or_default, to: :feed
end
