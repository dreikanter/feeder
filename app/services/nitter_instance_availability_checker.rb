class NitterInstanceAvailabilityChecker < ServiceInstanceAvailabilityChecker
  attr_reader :service_instance

  def initialize(service_instance)
    @service_instance = service_instance
  end

  def update_state
    service_instance.update!(state: available? ? ServiceInstance::STATE_ENABLED : ServiceInstance::STATE_DISABLED)
  end

  private

  def available?
    HTTP.timeout(5).get(sample_rss_url).code == 200
  rescue StandardError
    false
  end

  def sample_rss_url
    URI.join(service_instance.url, "_yesbut_/rss").to_s
  end
end
