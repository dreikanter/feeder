# Fetch the list of service URLs, check each instance availability, and update
# related ServiceInstance records
class ServiceInstancesPoolUpdater
  include Logging

  def call
    log_info("#{self.class}: importing public instances list")
    log_info("initial instances state: #{instances_stats}")
    disable_delisted_instances
    import_listed_instances
    log_info("updated instances state: #{instances_stats}")
  end

  private

  # @return [String] service type name (lowcase, underscore)
  def service_type
    raise AbstractMethodError
  end

  # @return [ServiceInstanceAvailabilityChecker]
  def availability_checker
    raise AbstractMethodError
  end

  # @return [ServiceInstancesFetcher]
  def instances_fetcher
    raise AbstractMethodError
  end

  def import_listed_instances
    instance_urls.each do |url|
      service_instance = find_or_create(url)
      service_instance.update!(state: actual_state(service_instance))
      service_instance.update!(errors_count: 0) if service_instance.enabled?
    end
  end

  def find_or_create(instance_url)
    ServiceInstance.find_or_create_by(service_type: service_type, url: instance_url)
  end

  def actual_state(service_instance)
    log_info("checking #{service_instance.url} availability")

    if availability_checker.new(service_instance).available?
      log_info("OK")
      ServiceInstance::STATE_ENABLED
    else
      log_error("not available")
      ServiceInstance::STATE_DISABLED
    end
  end

  def disable_delisted_instances
    delisted_instances.update_all(state: :disabled)
  end

  def delisted_instances
    scope.where.not(url: instance_urls)
  end

  def instance_urls
    @instance_urls ||= instances_fetcher.new.call
  end

  def instances_stats
    scope.select("state, COUNT(*) AS cnt").group(:state).map { "#{_1.state}: #{_1.cnt}" }.join("; ")
  end

  def scope
    ServiceInstance.where(service_type: service_type)
  end
end
