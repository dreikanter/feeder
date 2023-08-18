# Imports new posts with `PostsImporter` and publishes enqueued posts with `PostPublisher`
class FeedProcessor
  attr_reader :feed

  def initialize(feed)
    @feed = feed
  end

  def process
    import_new_posts
    # TODO: Run posts publishing
  end

  private

  def import_new_posts
    PostsImporter.new(feed).import
  end
end
