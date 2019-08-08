class BatchPullJob < ApplicationJob
  queue_as :default

  def perform
    stale_feeds.each do |feed|
      PullJob.perform_later(feed)
    end
  end

  private

  def stale_feeds
    active_feeds.select(&:stale?)
  end

  def active_feeds
    Service::FeedsList.call
  end
end
