require "rails_helper"

RSpec.describe ServiceInstancesFetcher do
  subject(:service) { described_class.new }

  it { expect { service.call }.to raise_error(AbstractMethodError) }
end
