require "rails_helper"

RSpec.describe LibredditInstanceAvailabilityChecker do
  subject(:update_state) { described_class.new(service_instance).update_state }

  let(:service_instance) { create(:service_instance, service_type: "libreddit", state: :enabled) }

  context "when instance is available" do
    before do
      stub_instance_request.to_return(status: 200)
      update_state
    end

    it { expect(service_instance.reload).to be_enabled }
  end

  context "when instance respond with a request error" do
    before do
      stub_instance_request.to_return(status: 404)
      update_state
    end

    it { expect(service_instance.reload).to be_disabled }
  end

  context "when instance raises an error" do
    before do
      stub_instance_request.to_raise(StandardError)
      update_state
    end

    it { expect(service_instance.reload).to be_disabled }
  end

  def stub_instance_request
    stub_request(:get, "#{service_instance.url}r/adventuretime")
  end
end
