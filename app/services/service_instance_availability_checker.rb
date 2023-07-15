class ServiceInstanceAvailabilityChecker
  attr_reader :service_instance

  def initialize(service_instance)
    @service_instance = service_instance
  end

  def update_state
    service_instance.update!(state: actual_state)
  end

  protected

  def available?
    raise AbstractMethodError
  end

  private

  def actual_state
    available? ? ServiceInstance::STATE_ENABLED : ServiceInstance::STATE_DISABLED
  end
end
