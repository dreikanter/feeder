namespace :feeder do
  desc "Import public Nitter instances list"
  task import_nitter_instances: :environment do
    NitterInstancesPoolUpdater.new.call
  end
end
