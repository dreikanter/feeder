class ServiceInstancesController < ApplicationController
  def index
    @grouped_service_instances = grouped_service_instances
  end

  private

  def grouped_service_instances
    {}.tap do |result|
      ServiceInstance.least_used.each do |service_instance|
        (result[service_instance.service_type] ||= []) << service_instance
      end
    end
  end
end
