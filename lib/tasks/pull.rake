namespace :feeder do
  desc 'Pull one specific feed: "rake feeder:pull[feed_name]"'
  task pull: :environment do |_task, args|
    # TODO: Move to a service
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
    # TODO: Move to a service
    feeds = Feed.stale.active

    # TODO: Limit batch size after Feed#stale? is fixed
    # .limit(Defaults::MAX_FEEDS_PER_BATCH)
    feeds_count = feeds.count

    if feeds_count.zero?
      Rails.logger.info('---> no stale feeds found, nothing to update')
    else
      feed_names = feeds.pluck(:name).join(', ')
      Rails.logger.info("---> updating #{feeds.count} feed(s): #{feed_names}")
      CreateDataPoint.call(:batch, feeds: feeds.pluck(:name))

      feeds.each do |feed|
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
end
