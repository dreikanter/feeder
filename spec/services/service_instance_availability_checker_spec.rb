require "rails_helper"

RSpec.describe ServiceInstanceAvailabilityChecker do
  subject(:service) { described_class.new(build(:service_instance)) }

  it { expect { service.update_state }.to raise_error(AbstractMethodError) }
end
