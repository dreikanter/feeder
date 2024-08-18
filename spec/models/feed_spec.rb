require "rails_helper"

RSpec.describe Feed do
  subject(:model) { described_class }

  describe "#readable_id" do
    it "returns expected value" do
      actual = model.new(id: 1, name: "sample").readable_id

      expect(actual).to eq("feed-1-sample")
    end
  end

  describe "#ensure_supported" do
    context "with missing loader" do
      it "raises an error" do
        stub_const("TestProcessor", Class.new)
        stub_const("TestNormalizer", Class.new)
        feed = model.new(loader: "missing", processor: "test", normalizer: "test")

        expect { feed.ensure_supported }.to raise_error(FeedConfigurationError)
      end
    end

    context "with missing processor" do
      it "raises an error" do
        stub_const("TestProcessor", Class.new)
        stub_const("TestLoader", Class.new)
        feed = model.new(loader: "test", processor: "missing", normalizer: "test")

        expect { feed.ensure_supported }.to raise_error(FeedConfigurationError)
      end
    end

    context "with missing normalizer" do
      it "raises an error" do
        stub_const("TestProcessor", Class.new)
        stub_const("TestNormalizer", Class.new)
        feed = model.new(loader: "test", processor: "test", normalizer: "missing")

        expect { feed.ensure_supported }.to raise_error(FeedConfigurationError)
      end
    end

    context "with existing processing classes" do
      it "returns true" do
        stub_const("TestLoader", Class.new)
        stub_const("TestProcessor", Class.new)
        stub_const("TestNormalizer", Class.new)
        feed = model.new(loader: "test", processor: "test", normalizer: "test")

        expect(feed.ensure_supported).to be(true)
      end
    end
  end

  describe "#loader_class" do
    it "resolves specified class" do
      stub_const("TestLoader", Class.new)
      feed = model.new(loader: "test")

      expect(feed.loader_class).to eq(TestLoader)
    end

    it { expect(model.new(processor: nil).loader_class).to be_nil }

    it { expect(model.new(processor: "missing").loader_class).to be_nil }
  end

  describe "#processor_class" do
    it "resolves specified class" do
      stub_const("TestProcessor", Class.new)
      model.new(processor: "test")

      expect(model.new(processor: "test").processor_class).to eq(TestProcessor)
    end

    it { expect(model.new(processor: nil).processor_class).to be_nil }

    it { expect(model.new(processor: "missing").processor_class).to be_nil }
  end

  describe "#normalizer_class" do
    it "resolves specified class" do
      stub_const("TestNormalizer", Class.new)
      model.new(normalizer: "test")

      expect(model.new(normalizer: "test").normalizer_class).to eq(TestNormalizer)
    end

    it { expect(model.new(normalizer: nil).normalizer_class).to be_nil }

    it { expect(model.new(normalizer: "missing").normalizer_class).to be_nil }
  end

  describe "#loader_instance" do
    it "instantiates a service" do
      stub_const("TestLoader", Class.new(FeedService))
      feed = model.new(loader: "test")
      instance = feed.loader_instance

      expect(instance).to be_a(TestLoader)
      expect(instance.feed).to eq(feed)
    end

    it do
      feed = model.new(loader: "missing")

      expect { feed.loader_instance }.to raise_error(StandardError)
    end
  end

  describe "#processor_instance" do
    it "instantiates a service" do
      stub_const("TestProcessor", Class.new(FeedService))
      feed = model.new(processor: "test")
      instance = feed.processor_instance

      expect(instance).to be_a(TestProcessor)
      expect(instance.feed).to eq(feed)
    end

    it do
      feed = model.new(processor: "missing")

      expect { feed.processor_instance }.to raise_error(StandardError)
    end
  end

  describe "#normalizer_instance" do
    it "instantiates a service" do
      stub_const("TestNormalizer", Class.new(FeedService))
      feed = model.new(normalizer: "test")
      instance = feed.normalizer_instance

      expect(instance).to be_a(TestNormalizer)
      expect(instance.feed).to eq(feed)
    end

    it do
      feed = model.new(normalizer: "missing")

      expect { feed.normalizer_instance }.to raise_error(StandardError)
    end
  end

  describe "#service_classes" do
    it "returns a hash" do
      stub_const("TestLoader", Class.new)
      stub_const("TestProcessor", Class.new)
      stub_const("TestNormalizer", Class.new)
      feed = model.new(loader: "test", processor: "test", normalizer: "test")

      expected = {
        loader_class: TestLoader,
        processor_class: TestProcessor,
        normalizer_class: TestNormalizer
      }

      expect(feed.service_classes).to eq(expected)
    end

    it "tolerates missing service classes" do
      feed = model.new(loader: "test", processor: "test", normalizer: "test")

      expected = {
        loader_class: nil,
        processor_class: nil,
        normalizer_class: nil
      }

      expect(feed.service_classes).to eq(expected)
    end
  end
end
