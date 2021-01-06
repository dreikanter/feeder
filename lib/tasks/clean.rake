namespace :feeder do
  desc 'Clean old data points'
  task clean: :environment do
    count = PurgeDataPoints.call
    Rails.logger.info("#{count} old data points purged")
    count = PurgeErrors.call
    Rails.logger.info("#{count} old errors purged")
  end
end
