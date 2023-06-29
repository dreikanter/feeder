class UpdateSubscriptionsCount
  include Callee

  param :feed_name
  option :freefeed_client, optional: true, default: -> { FreefeedClientBuilder.call }

  def call
    feed.update(subscriptions_count: fetch_subscriptions_count)
  end

  private

  def fetch_subscriptions_count
    timeline = freefeed_client.timeline(feed_name)
    subscribers = timeline.parse.dig("timelines", "subscribers")
    subscribers.count
  end

  def feed
    Feed.find_by(name: feed_name)
  end
end
