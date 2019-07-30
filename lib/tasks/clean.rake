require_relative '../../app/service/purge_data_points'

namespace :feeder do
  desc 'Clean old data points'
  task clean: :environment do
    count = Service::PurgeDataPoints.call
    Rails.logger.info("#{count} old data points purged")
  end
end
