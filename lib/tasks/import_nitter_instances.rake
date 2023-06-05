namespace :feeder do
  desc 'Import public Nitter instances list'
  task import_nitter_instances: :environment do
    Rails.logger.info("---> importing nitter instances...")
    stats = -> { NitterInstance.all.select("status, COUNT(*) AS cnt").group(:status).map { "#{_1.status}: #{_1.cnt}" }.join("; ") }
    Rails.logger.info("---> initial state: #{stats.call}")
    NitterInstancesPoolUpdater.call
    Rails.logger.info("---> updated state: #{stats.call}")
  end
end
