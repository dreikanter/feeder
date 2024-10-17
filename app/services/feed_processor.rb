# Import content for each feed in the specified scope, and publish new posts.
#
class FeedProcessor
  include Logging

  attr_reader :feeds

  # @param feeds: [Enumerable<Feed>] feeds to process
  def initialize(feeds:)
    @feeds = feeds
  end

  # TBD: This should receive "stale enabled" feeds; test Feed model scopes
  def perform
    feeds.each do |feed|
      Importer.new(feed).import
      Publisher.new(posts: feed.posts.pending).publish
      # TBD: HAndle errors
    end
  end
end
