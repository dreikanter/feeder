namespace :feeder do
  desc "Import public Nitter instances list"
  task import_nitter_instances: :environment do
    Rails.logger.info("---> initial state: #{nitter_instances_stats}")
    NitterInstancesPoolUpdater.new.call
    Rails.logger.info("---> updated state: #{nitter_instances_stats}")
  end

  def nitter_instances_stats
    ServiceInstance.all.select("state, COUNT(*) AS cnt").group(:state).map { "#{_1.state}: #{_1.cnt}" }.join("; ")
  end
end
