namespace :feeder do
  desc "Update Freefeed subscriptions count"
  task subs: :environment do
    series_name = "subs"
    expiration_threshold = 2.hours.ago

    # Limit for the amount of feeds to be updated in one batch. Updates frequency
    # will depend on this setting and cron configuration for the current task.
    throttling_limit = 5

    # TODO: Move to a query class and test auto-rotation
    recently_updated_feed_names = DataPoint
      .for(series_name)
      .where("created_at > ?", expiration_threshold)
      .select("details->'feed_name' as feed_name")
      .map(&:feed_name)
      .uniq

    feeds_to_update = Feed.active.pluck(:name) - recently_updated_feed_names

    feeds_to_update.slice(0, throttling_limit).each do |feed_name|
      Rails.logger.info("---> updating subscriptions count for #{feed_name}")
      UpdateSubscriptionsCount.call(feed_name)
    end
  end
end
