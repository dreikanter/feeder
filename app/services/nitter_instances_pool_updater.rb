class NitterInstancesPoolUpdater
  def call
    disable_delisted_instances
    import_listed_instances
  end

  private

  def import_listed_instances
    instance_urls.each { find_or_create(_1) }
  end

  def find_or_create(instance_url)
    ServiceInstance.find_or_create_by(service_type: "nitter", url: instance_url).tap do |service_instance|
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
end
