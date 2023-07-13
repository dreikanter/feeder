class NitterInstancesPoolUpdater
  include Logging

  def call
    logger.info("importing public nitter instances list")
    logger.info("initial instances state: #{nitter_instances_stats}")
    disable_delisted_instances
    import_listed_instances
    logger.info("updated instances state: #{nitter_instances_stats}")
  end

  private

  def import_listed_instances
    instance_urls.each { find_or_create(_1) }
  end

  def find_or_create(instance_url)
    ServiceInstance.find_or_create_by(service_type: "nitter", url: instance_url).tap do |service_instance|
      logger.info("checking #{instance_url} availability")
      NitterInstanceAvailabilityChecker.new(service_instance).update_state
    end
  end

  def disable_delisted_instances
    delisted_instances.update_all(state: :disabled)
  end

  def delisted_instances
    ServiceInstance.where(service_type: "nitter").where.not(url: instance_urls)
  end

  def instance_urls
    @instance_urls ||= NitterInstancesFetcher.new.call
  end

  def nitter_instances_stats
    ServiceInstance.all.select("state, COUNT(*) AS cnt").group(:state).map { "#{_1.state}: #{_1.cnt}" }.join("; ")
  end
end
