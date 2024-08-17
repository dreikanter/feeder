# Import content for each feed in the specified scope, and publish new posts.
#
class FeedProcessor < FeedService
  include Logging

  attr_reader :feeds

  # @param feeds: [Enumerable<Feed>] feeds to process
  def initialize(feeds:)
    @feeds = feeds
  end

  def perform
    feeds.each do |feed|
      FeedImporter.new(feed: feed).perform
      Publisher.new(posts: feed.posts.pending).publish
    rescue StandardError
      log_error("feed processing interrupted: #{feed.name} (id: #{feed.id})")
    end
  end
end
