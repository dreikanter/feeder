require "rails_helper"
require_relative "../support/test_loader"

RSpec.describe FeedEntitiesFetcher do
  subject(:service_call) { described_class.new(feed).fetch }

  context "with missing loader" do
    let(:feed) { build(:feed, loader: "missing") }

    it { expect(service_call).to be_empty }
  end

  context "with missing processor" do
    let(:feed) { build(:feed, loader: "test", processor: "missing") }

    it { expect(service_call).to be_empty }
  end
end
