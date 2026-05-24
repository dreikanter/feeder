require "rails_helper"

RSpec.describe NitterInstanceAvailabilityChecker do
  subject(:result) { described_class.new(service_instance).available? }

  let(:service_instance) { create(:service_instance, service_type: "nitter", state: :enabled) }
  let(:feed_content) { file_fixture("feeds/nitter/rss.xml").read }

  context "when instance returns a parseable feed" do
    before { stub_instance_request.to_return(status: 200, body: feed_content) }

    it { expect(result).to be_truthy }
  end

  context "when instance does not support RSS" do
    before { stub_instance_request.to_return(status: 404) }

    it { expect(result).to be_falsey }
  end

  context "when instance returns unparseable content with a success status" do
    before { stub_instance_request.to_return(status: 200, body: "<html>rate limited</html>") }

    it { expect(result).to be_falsey }
  end

  context "when instance raises an error" do
    before { stub_instance_request.to_raise(StandardError) }

    it { expect(result).to be_falsey }
  end

  def stub_instance_request
    stub_request(:get, "#{service_instance.url}_yesbut_/rss")
  end
end
