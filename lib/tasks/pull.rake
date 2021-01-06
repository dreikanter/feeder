namespace :feeder do
  desc 'Pull one specific feed: "rake feeder:pull[feed_name]"'
  task pull: :environment do |_task, args|
    feed_name = args.extras[0]
    raise 'feed name is required' unless feed_name
    feed = Feed.active.find_by(name: feed_name)
    raise 'specified feed does not exist or inactive' unless feed
    Import.call(feed)
  end

  desc 'Pull all feeds'
  task pull_all: :environment do
    Feed.active.each { |feed| Import.call(feed) }
  end

  desc 'Pull stale feeds'
  task pull_stale: :environment do
    stale_feeds = Feed.stale
    Rails.logger.info("---> batch update: #{stale_feeds.count} feed(s)")
    CreateDataPoint.call(:batch, feeds: stale_feeds.pluck(:name))

    stale_feeds.each do |feed|
      # TODO: Exclude inactive feeds from stale scope
      Import.call(feed) if feed.active?
    rescue StandardError => e
      ErrorDumper.call(
        exception: e,
        message: 'Error importing feed',
        target: feed
      )
      next
    end
  end
end
