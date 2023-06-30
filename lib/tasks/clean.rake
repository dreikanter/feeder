namespace :feeder do
  desc "Purge obsolete data"
  task clean: :environment do
    count = PurgeErrors.call(before: 1.month.ago)
    Rails.logger.info("#{count} old errors purged")
  end
end
