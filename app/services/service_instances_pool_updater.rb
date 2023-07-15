class ServiceInstancesPoolUpdater
  include Logging

  def call
    logger.info("#{self.class.name}: importing public instances list")
    logger.info("initial instances state: #{instances_stats}")
    disable_delisted_instances
    import_listed_instances
    logger.info("updated instances state: #{instances_stats}")
  end

  protected

  def service_type
    raise AbstractMethodError
  end

  def availability_checker
    raise AbstractMethodError
  end

  def instances_fetcher
    raise AbstractMethodError
  end

  private

  def import_listed_instances
    instance_urls.each { find_or_create(_1) }
  end

  def find_or_create(instance_url)
    ServiceInstance.find_or_create_by(service_type: service_type, url: instance_url).tap do |service_instance|
      logger.info("checking #{instance_url} availability")
      availability_checker.new(service_instance).update_state
    end
  end

  def disable_delisted_instances
    delisted_instances.update_all(state: :disabled)
  end

  def delisted_instances
    ServiceInstance.where(service_type: "nitter").where.not(url: instance_urls)
  end

  def instance_urls
    @instance_urls ||= instances_fetcher.new.call
  end

  def instances_stats
    ServiceInstance.all.select("state, COUNT(*) AS cnt").group(:state).map { "#{_1.state}: #{_1.cnt}" }.join("; ")
  end
end
