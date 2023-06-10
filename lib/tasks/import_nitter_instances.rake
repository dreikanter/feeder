namespace :feeder do
  desc 'Import public Nitter instances list'
  task import_nitter_instances: :environment do
    Rails.logger.info('---> importing nitter instances...')
    Rails.logger.info("---> initial state: #{NitterInstance.stats}")
    NitterInstancesPoolUpdater.call
    Rails.logger.info("---> updated state: #{NitterInstance.stats}")
  end
end
