namespace :feeder do
  desc "Import public Nitter instances list"
  task import_nitter_instances: :environment do
    Rails.logger.info("---> importing nitter instances...")
    stats = -> { ServiceInstance.all.select("state, COUNT(*) AS cnt").group(:state).map { "#{_1.state}: #{_1.cnt}" }.join("; ") }
    Rails.logger.info("---> initial state: #{stats.call}")
    NitterInstancesPoolUpdater.new.call
    Rails.logger.info("---> updated state: #{stats.call}")
  end
end
