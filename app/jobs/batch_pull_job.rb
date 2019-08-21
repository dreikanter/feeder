class BatchPullJob < ApplicationJob
  queue_as :default

  def perform
    logger.info("batch update: #{stale_feeds.count} feed(s)")
    Feed.stale.each do |feed|
      PullJob.perform_later(feed)
    end
  end
end
