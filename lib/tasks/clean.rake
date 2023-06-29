namespace :feeder do
  desc "Purge obsolete data"
  task clean: :environment do
    count = PurgeErrors.call
    Rails.logger.info("#{count} old errors purged")
  end
end
