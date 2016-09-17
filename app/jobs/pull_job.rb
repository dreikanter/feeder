class PullJob < ApplicationJob
  queue_as :default

  def perform(feed_name)
    Service::FeedLoader.load(feed_name).each { |p| PushJob.perform_later p }
  end
end
