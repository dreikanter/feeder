# Import content for each feed in the specified scope, and publish new posts.
#
class FeedProcessor
  include Logging

  attr_reader :feeds

  # @param feeds: [Enumerable<Feed>] feeds to process
  def initialize(feeds:)
    @feeds = feeds
  end

  def perform
    feeds.each do |feed|
      Importer.new(feed: feed).import
      Publisher.new(posts: feed.posts.pending).publish
    rescue StandardError
      logger.error { "feed processing interrupted: #{feed.name} (id: #{feed.id})" }
    end
  end
end
