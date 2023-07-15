namespace :feeder do
  desc "Import public Libreddit instances list"
  task import_libreddit_instances: :environment do
    LibredditInstancesPoolUpdater.new.call
  end
end
