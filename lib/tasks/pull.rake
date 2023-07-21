namespace :feeder do
  desc 'Pull specific feed: "rake feeder:pull[feed_name]"'
  task pull: :environment do |_task, args|
    feed_name = args.extras.fetch(0) { abort "undefined feed name" }
    ScopedFeedsImporter.import { Feed.enabled.where(name: feed_name) }
  end

  desc "Pull all ENABLED feeds"
  task pull_all: :environment do
    ScopedFeedsImporter.import { Feed.enabled }
  end

  desc "Pull all STALE feeds"
  task pull_stale: :environment do
    ScopedFeedsImporter.import { Feed.enabled.stale }
  end
end
