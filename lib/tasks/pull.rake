namespace :feeder do
  desc 'Pull one specific feed: "rake feeder:pull[feed_name]"'
  task pull: :environment do |_task, args|
    # TODO: Move to a service
    feed_name = args.extras[0]
    raise 'feed name is required' unless feed_name
    feed = Feed.active.find_by(name: feed_name)
    raise 'specified feed does not exist or inactive' unless feed
    ProcessFeed.call(feed)
  end

  desc 'Pull all feeds'
  task pull_all: :environment do
    Feed.active.each { |feed| ProcessFeed.call(feed) }
  end

  desc 'Pull stale feeds'
  task pull_stale: :environment do
    # TODO: Move to a service
    feeds = Feed.stale.active

    # TODO: Limit batch size after Feed#stale? is fixed
    # .limit(Defaults::MAX_FEEDS_PER_BATCH)

    feed_names = feeds.pluck(:name).join(', ')
    Rails.logger.info("---> updating #{feeds.count} feed(s): #{feed_names}")
    data_point = CreateDataPoint.call(:batch, feeds: feeds.pluck(:name))

    feeds.each do |feed|
      ProcessFeed.call(feed)
    rescue StandardError => e
      ErrorDumper.call(
        exception: e,
        message: 'Error processing feed',
        target: feed,
        context: { batch_data_point: data_point.id }
      )

      next
    end
  end
end
