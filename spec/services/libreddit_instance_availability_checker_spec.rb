require "rails_helper"

RSpec.describe LibredditInstanceAvailabilityChecker do
  subject(:result) { described_class.new(service_instance).available? }

  let(:service_instance) { create(:service_instance, service_type: "libreddit", state: :enabled) }

  context "when instance is available" do
    before { stub_instance_request.to_return(status: 200) }

    it { expect(result).to be_truthy }
  end

  context "when instance respond with a request error" do
    before { stub_instance_request.to_return(status: 404) }

    it { expect(result).to be_falsey }
  end

  context "when instance raises an error" do
    before { stub_instance_request.to_raise(StandardError) }

    it { expect(result).to be_falsey }
  end

  def stub_instance_request
    stub_request(:get, "#{service_instance.url}r/adventuretime")
  end
end
