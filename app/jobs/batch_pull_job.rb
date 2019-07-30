class BatchPullJob < ApplicationJob
  queue_as :default

  def perform
    batch = Service::CreateDataPoint.call(:batch, started_at: Time.now.utc)
    update_inactive_feeds_status
    active_feed_names.each do |feed_name|
      feed = Service::FeedBuilder.call(feed_name)
      PullJob.perform_later(feed, batch) if feed.stale?
    end
  end

  def active_feed_names
    @active_feed_names ||= Service::FeedsList.names
  end

  def update_inactive_feeds_status
    inactive = Enums::FeedStatus.inactive
    Feed.where.not(name: active_feed_names).update_all(status: inactive)
  end
end
