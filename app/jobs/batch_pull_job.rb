class BatchPullJob < ApplicationJob
  queue_as :default

  def perform
    stale_feeds.each(PullJob.method(:perform_later))
  end

  private

  def stale_feeds
    active_feeds.select(&:stale?)
  end

  def active_feeds
    Service::FeedsList.names.map(&Service::FeedBuilder)
  end
end
