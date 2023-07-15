class NitterInstancesPoolUpdater < ServiceInstancesPoolUpdater
  protected

  def service_type
    "nitter"
  end

  def availability_checker
    NitterInstanceAvailabilityChecker
  end

  def instances_fetcher
    NitterInstancesFetcher
  end
end
