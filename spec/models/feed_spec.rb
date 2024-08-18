require "rails_helper"

RSpec.describe Feed do
  subject(:model) { described_class }

  describe "#readable_id" do
    it "should return expected value" do
      actual = model.new(id: 1, name: "sample").readable_id

      expect(actual).to eq("feed-1-sample")
    end
  end

  describe "#ensure_supported" do
    context "with missing loader" do
      it "should raise an error" do
        stub_const("TestProcessor", Class.new)
        stub_const("TestNormalizer", Class.new)
        feed = build(:feed, loader: "missing", processor: "test", normalizer: "test")

        expect { feed.ensure_supported }.to raise_error(FeedConfigurationError)
      end
    end

    context "with missing processor" do
      it "should raise an error" do
        stub_const("TestProcessor", Class.new)
        stub_const("TestLoader", Class.new)
        feed = build(:feed, loader: "test", processor: "missing", normalizer: "test")

        expect { feed.ensure_supported }.to raise_error(FeedConfigurationError)
      end
    end

    context "with missing normalizer" do
      it "should raise an error" do
        stub_const("TestProcessor", Class.new)
        stub_const("TestNormalizer", Class.new)
        feed = build(:feed, loader: "test", processor: "test", normalizer: "missing")

        expect { feed.ensure_supported }.to raise_error(FeedConfigurationError)
      end
    end

    context "with existing processing classes" do
      it "should return true" do
        stub_const("TestLoader", Class.new)
        stub_const("TestProcessor", Class.new)
        stub_const("TestNormalizer", Class.new)
        feed = build(:feed, loader: "test", processor: "test", normalizer: "test")

        expect(feed.ensure_supported).to eq(true)
      end
    end
  end

  describe "#loader_class" do
    it "resolves specified class" do
      stub_const("TestLoader", Class.new)
      feed = build(:feed, loader: "test")

      expect(feed.loader_class).to eq(TestLoader)
    end

    it { expect(build(:feed, processor: nil).loader_class).to be_nil }

    it { expect(build(:feed, processor: "missing").loader_class).to be_nil }
  end

  describe "#processor_class" do
    it "resolves specified class" do
      stub_const("TestProcessor", Class.new)
      feed = build(:feed, processor: "test")

      expect(build(:feed, processor: "test").processor_class).to eq(TestProcessor)
    end

    it { expect(build(:feed, processor: nil).processor_class).to be_nil }

    it { expect(build(:feed, processor: "missing").processor_class).to be_nil }
  end

  describe "#normalizer_class" do
    it "resolves specified class" do
      stub_const("TestNormalizer", Class.new)
      feed = build(:feed, normalizer: "test")

      expect(build(:feed, normalizer: "test").normalizer_class).to eq(TestNormalizer)
    end

    it { expect(build(:feed, normalizer: nil).normalizer_class).to be_nil }

    it { expect(build(:feed, normalizer: "missing").normalizer_class).to be_nil }
  end

  describe "#loader_instance" do
    it "instantiates a service" do
      stub_const("TestLoader", Class.new(FeedService))
      feed = build(:feed, loader: "test")
      instance = feed.loader_instance

      expect(instance).to be_a(TestLoader)
      expect(instance.feed).to eq(feed)
    end

    it do
      feed = build(:feed, loader: "missing")

      expect { feed.loader_instance }.to raise_error(StandardError)
    end
  end

  describe "#processor_instance" do
    it "instantiates a service" do
      stub_const("TestProcessor", Class.new(FeedService))
      feed = build(:feed, processor: "test")
      instance = feed.processor_instance

      expect(instance).to be_a(TestProcessor)
      expect(instance.feed).to eq(feed)
    end

    it do
      feed = build(:feed, processor: "missing")

      expect { feed.processor_instance }.to raise_error(StandardError)
    end
  end

  describe "#normalizer_instance" do
    it "instantiates a service" do
      stub_const("TestNormalizer", Class.new(FeedService))
      feed = build(:feed, normalizer: "test")
      instance = feed.normalizer_instance

      expect(instance).to be_a(TestNormalizer)
      expect(instance.feed).to eq(feed)
    end

    it do
      feed = build(:feed, normalizer: "missing")

      expect { feed.normalizer_instance }.to raise_error(StandardError)
    end
  end
end
