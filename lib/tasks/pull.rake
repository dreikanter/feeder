namespace :feeder do
  desc "Update feeds configuration"
  task configuration: :environment do
    FeedsConfiguration.sync
  end

  desc "Pull one specific feed: rake feeder:pull[feed_name]"
  task pull: :configuration do |_task, args|
    # TODO: Move to a service
    feed_name = args.extras[0]
    raise "feed name is required" unless feed_name
    feed = Feed.enabled.find_by(name: feed_name)
    raise "specified feed does not exist or enabled" unless feed
    ProcessFeed.new(feed).process
  end

  desc "Pull all feeds"
  task pull_all: :configuration do
    Feed.enabled.each { |feed| ProcessFeed.new(feed).process }
  end

  desc "Pull stale feeds"
  task pull_stale: :configuration do
    # TODO: Move to a service
    feeds = Feed.enabled.stale
    feeds.each { |feed| ProcessFeed.new(feed).process }
  end
end
