SERIES_NAME = 'subs'
EXPIRATION_THRESHOLD = 2.hours.ago

# Limit for the amount of feeds to be updated in one batch
THROTTLING_LIMIT = 5

desc 'Update Freefeed subscriptions count'
task subs: :environment do
  recently_updated_feed_names = DataPoint
    .for(SERIES_NAME)
    .where('created_at > ?', EXPIRATION_THRESHOLD)
    .select("details->'feed_name' as feed_name")
    .map(&:feed_name)
    .uniq

  feeds_to_update = Service::FeedsList.names - recently_updated_feed_names

  feeds_to_update.slice(0, THROTTLING_LIMIT).each do |feed_name|
    UpdateSubscriptionsCountJob.perform_later(feed_name)
  end
end
