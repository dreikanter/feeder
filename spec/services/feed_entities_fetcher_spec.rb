require "rails_helper"

RSpec.describe FeedEntitiesFetcher do
  subject(:service_call) { described_class.new(feed).fetch }

  let(:test_loader) do
    Class.new(BaseLoader) do
      def content
        "banana,banana,banana"
      end
    end
  end

  let(:test_processor) do
    Class.new(BaseProcessor) do
      def entities
        [FeedEntity.new(uid: "1", content: "banana", feed: feed)]
      end
    end
  end

  let(:faulty_loader) do
    Class.new(BaseLoader) do
      def content
        raise "loader error"
      end
    end
  end

  let(:faulty_processor) do
    Class.new(BaseProcessor) do
      def entities
        raise "processor error"
      end
    end
  end

  before do
    stub_const("TestLoader", test_loader)
    stub_const("TestProcessor", test_processor)
    stub_const("FaultyLoader", faulty_loader)
    stub_const("FaultyProcessor", faulty_processor)
  end

  context "with missing loader" do
    let(:feed) { build(:feed, loader: "missing") }

    it { expect(service_call).to be_empty }
  end

  context "with missing processor" do
    let(:feed) { build(:feed, loader: "test", processor: "missing") }

    it { expect(service_call).to be_empty }
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
