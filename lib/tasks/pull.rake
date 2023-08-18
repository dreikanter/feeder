namespace :feeder do
  desc 'Pull one specific feed: "rake feeder:pull[feed_name]"'
  task pull: :environment do |_task, args|
    feed_name = args.extras[0]
    raise "feed name is required" unless feed_name
    ScopedFeedsProcessor.process { Feed.enabled.where(name: feed_name) }
  end

  desc "Pull all feeds"
  task pull_all: :environment do
    ScopedFeedsProcessor.process { Feed.enabled }
  end

  desc "Pull stale feeds"
  task pull_stale: :environment do
    ScopedFeedsProcessor.process { Feed.enabled.stale }
  end
end
