class BatchPullJob < ApplicationJob
  queue_as :default

  def perform
    stale_feeds = Feed.stale
    logger.info("batch update: #{stale_feeds.count} feed(s)")
    CreateDataPoint.call(:batch, feeds: stale_feeds.pluck(:name))
    stale_feeds.each do |feed|
      PullJob.perform_later(feed)
    end
  end
end
