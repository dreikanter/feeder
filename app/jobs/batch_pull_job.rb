class BatchPullJob < ApplicationJob
  queue_as :default

  def perform
    batch = Service::CreateDataPoint.call(:batch, started_at: Time.now.utc)
    names = Service::FeedsList.names
    Feed.where(name: names).update_all(status: Enums::FeedStatus.active)
    Feed.where.not(name: names).update_all(status: Enums::FeedStatus.inactive)
    names.each { |feed_name| PullJob.perform_later(feed_name, batch) }
  end
end
