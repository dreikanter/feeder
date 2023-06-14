namespace :feeder do
  desc 'Pull one specific feed: "rake feeder:pull[feed_name]"'
  task pull: :environment do |_task, args|
    # TODO: Move to a service
    feed_name = args.extras[0]
    raise "feed name is required" unless feed_name
    FeedsConfiguration.sync
    feed = Feed.enabled.find_by(name: feed_name)
    raise "specified feed does not exist or enabled" unless feed
    ProcessFeed.call(feed)
  end

  desc "Pull all feeds"
  task pull_all: :environment do
    FeedsConfiguration.sync
    Feed.enabled.each { |feed| ProcessFeed.call(feed) }
  end

  desc "Pull stale feeds"
  task pull_stale: :environment do
    # TODO: Move to a service
    FeedsConfiguration.sync
    feeds = Feed.enabled.stale
    feed_names = feeds.pluck(:name).join(", ")
    Rails.logger.info("---> updating #{feeds.count} feed(s): #{feed_names}")
    feeds.each { |feed| ProcessFeed.call(feed) }
  end
end
