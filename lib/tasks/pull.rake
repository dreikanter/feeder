require_relative '../../app/service/feed_sanitizer'
require_relative '../../app/service/feeds_list'

namespace :pull do
  Service::FeedsList.names.each do |feed_name|
    desc "Pull #{feed_name} feed"
    task feed_name => :environment do
      PullJob.perform_later(feed_name)
    end
  end

  desc 'Pull all feeds'
  task all: :environment do
    Service::FeedsList.names.each do |feed_name|
      PullJob.perform_later(feed_name)
    end
  end

  desc 'Pull stale feeds'
  task stale: :environment do
    BatchPullJob.perform_later
  end
end
