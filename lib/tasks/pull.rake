namespace :feeder do
  desc 'Pull one specific feed: "rake feeder:pull[feed_name]"'
  task pull: :environment do |_task, args|
    feed_name = args.extras[0]
    raise 'feed name is required' unless feed_name
    feed = Feed.active.find_by(name: feed_name)
    raise 'specified feed does not exist or inactive' unless feed
    ImportJob.perform_later(feed)
  end

  desc 'Pull all feeds'
  task pull_all: :environment do
    Feed.active.each do |feed|
      ImportJob.perform_later(feed)
    end
  end

  desc 'Pull stale feeds'
  task pull_stale: :environment do
    BatchImportJob.perform_later
  end
end
