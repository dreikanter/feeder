class UpdateSubscriptionsCountJob < ApplicationJob
  queue_as :default

  SERIES_NAME = 'subs'.freeze

  def perform(feed_name)
    data_point = prev_data_point(feed_name)
    current = fetch_current_count(feed_name)

    if data_point.present? && data_point.details['count'] == current
      data_point.touch(:created_at)
      return
    end

    Rails.logger.info("new subscriptions count: #{current}")
    DataPoint.create_subs(feed_name: feed_name, count: current)
    Feed.find_by(name: feed_name).update(subscriptions_count: current)
  end

  def freefeed
    @freefeed ||=
      Freefeed::Client.new(Rails.application.credentials.freefeed_token)
  end

  def prev_data_point(feed_name)
    DataPoint
      .for(SERIES_NAME)
      .where("details->>'feed_name' = ?", feed_name)
      .order(created_at: :desc)
      .first
  end

  def fetch_current_count(feed_name)
    Rails.logger.info("fetching group details: #{feed_name}")
    timeline = freefeed.get_timeline(feed_name)
    subscribers = timeline.dig('timelines', 'subscribers')
    subscribers.count
  end
end
