class UpdateSubscriptionsCount
  include Callee

  param :feed_name

  SERIES_NAME = :subs

  def call
    update_or_create_data_point
    update_feed
  end

  private

  def update_or_create_data_point
    return unless prev_count != current_count
    CreateDataPoint.call(:subs, details: {feed_name: feed_name, count: current_count})
  end

  def prev_count
    prev_data_point.try(:details).try(:[], "count")
  end

  def prev_data_point
    DataPoint
      .for(SERIES_NAME)
      .where("details->>'feed_name' = ?", feed_name)
      .order(created_at: :desc)
      .first
  end

  def current_count
    @current_count ||= fetch_current_count
  end

  def fetch_current_count
    Rails.logger.info("fetching group details: #{feed_name}")
    timeline = freefeed.timeline(feed_name)
    subscribers = timeline.parse.dig("timelines", "subscribers")
    subscribers.count
  end

  def freefeed
    FreefeedClientBuilder.call
  end

  def update_feed
    feed.update(subscriptions_count: current_count)
  end

  def feed
    Feed.enabled.find_by(name: feed_name)
  end
end
