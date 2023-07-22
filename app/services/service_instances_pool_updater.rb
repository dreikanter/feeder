# Fetch the list of service URLs, check each instance availability, and update
# related ServiceInstance records
class ServiceInstancesPoolUpdater
  include Logging

  def call
    log_info("#{self.class.name}: importing public instances list")
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
    end
  end

  def find_or_create(instance_url)
    ServiceInstance.find_or_create_by(service_type: service_type, url: instance_url)
  end

  def actual_state(service_instance)
    log_info("checking #{service_instance.url} availability")
    availability_checker.new(service_instance).available? ? ServiceInstance::STATE_ENABLED : ServiceInstance::STATE_DISABLED
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
