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
      Importer.new(feed).import
      BatchPublisher.new(posts: feed.posts.pending, freefeed_client: build_freefeed_client).publish

      # TBD: Handle errors
    end
  end

  private

  def build_freefeed_client
    feeder = Rails.configuration.feeder

    Freefeed::Client.new(
      token: feeder.freefeed_token,
      base_url: feeder.freefeed_base_url
    )
  end
end
