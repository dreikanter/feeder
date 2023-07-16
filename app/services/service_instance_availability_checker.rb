class ServiceInstanceAvailabilityChecker
  attr_reader :service_instance

  def initialize(service_instance)
    @service_instance = service_instance
  end

  def available?
    raise AbstractMethodError
  end
end
