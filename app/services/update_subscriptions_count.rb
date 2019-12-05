class UpdateSubscriptionsCount
  include Callee

  param :feed_name

  SERIES_NAME = :subs

  def call
    data_point = prev_data_point(feed_name)
    current = fetch_current_count(feed_name)

    if data_point.present? && data_point.details['count'] == current
      data_point.touch(:created_at)
    else
      Rails.logger.info("new subscriptions count: #{current}")
      CreateDataPoint.call(:subs, feed_name: feed_name, count: current)
      Feed.active.find_by(name: feed_name).update(subscriptions_count: current)
    end

    current
  end

  private

  def prev_data_point(feed_name)
    DataPoint
      .for(SERIES_NAME)
      .where("details->>'feed_name' = ?", feed_name)
      .order(created_at: :desc)
      .first
  end

  def fetch_current_count(feed_name)
    Rails.logger.info("fetching group details: #{feed_name}")
    timeline = freefeed.timeline(feed_name)
    subscribers = timeline.parse.dig('timelines', 'subscribers')
    subscribers.count
  end

  def freefeed
    @freefeed ||= FreefeedClientBuilder.call
  end
end
