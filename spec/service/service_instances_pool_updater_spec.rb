require "rails_helper"

RSpec.describe ServiceInstancesPoolUpdater do
  subject(:service) { described_class.new }

  it { expect(service).to respond_to(:call) }
  it { expect { service.call }.to raise_error(AbstractMethodError) }
end
