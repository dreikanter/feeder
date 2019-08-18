class BatchPullJob < ApplicationJob
  queue_as :default

  def perform
    logger.info("batch update: #{stale_feeds.count} feed(s)")
    stale_feeds.each do |feed|
      PullJob.perform_later(feed)
    end
  end

  private

  def stale_feeds
    @stale_feeds ||= active_feeds.select(&:stale?)
  end

  def active_feeds
    FeedsList.call
  end
end
