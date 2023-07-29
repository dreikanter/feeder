require "rails_helper"
require "support/shared_test_loaders"
require "support/shared_test_processors"

RSpec.describe FeedEntitiesFetcher do
  subject(:service_call) { described_class.new(feed).fetch }

  include_context "with test loaders"
  include_context "with test processors"

  context "with missing loader" do
    let(:feed) { build(:feed, loader: "missing") }

    it { expect { service_call }.to raise_error(NameError) }
  end

  context "with missing processor" do
    let(:feed) { build(:feed, loader: "test", processor: "missing") }

    it { expect { service_call }.to raise_error(NameError) }
  end

  context "when on a happy path" do
    let(:feed) { build(:feed, loader: "test", processor: "test") }

    it { expect(service_call).to eq([FeedEntity.new(uid: "1", content: "banana", feed: feed)]) }
  end

  context "with loader error" do
    let(:feed) { build(:feed, loader: "faulty") }

    it { expect { service_call }.to raise_error("loader error") }
  end

  context "with processor error" do
    let(:feed) { build(:feed, loader: "test", processor: "faulty") }

    it { expect { service_call }.to raise_error("processor error") }
  end
end
