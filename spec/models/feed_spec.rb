require "rails_helper"

RSpec.describe Feed do
  subject(:model) { described_class }

  let(:arbitrary_time) { Time.current }

  # TBD
  # describe "validations" do
  # end

  describe "#configurable?" do
    context "with missing timestamps" do
      it "returns true" do
        expect(model.new(updated_at: arbitrary_time, configured_at: nil)).to be_configurable
        expect(model.new(updated_at: true, configured_at: arbitrary_time)).to be_configurable
        expect(model.new(updated_at: nil, configured_at: nil)).to be_configurable
      end
    end

    context "when last update was before or during previous configuration" do
      it "returns true" do
        expect(model.new(updated_at: arbitrary_time, configured_at: arbitrary_time)).to be_configurable
        expect(model.new(updated_at: arbitrary_time - 1.second, configured_at: arbitrary_time)).to be_configurable
      end
    end

    context "when last update was manual" do
      it "returns false" do
        expect(model.new(updated_at: arbitrary_time + 1.second, configured_at: arbitrary_time)).not_to be_configurable
      end
    end
  end

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
      stub_const("TestLoader", Class.new(BaseLoader))
      feed = model.new(loader: "test")

      expect(feed.loader_class).to eq(TestLoader)
    end

    it { expect(model.new(processor: nil).loader_class).to be_nil }

    it { expect(model.new(processor: "missing").loader_class).to be_nil }
  end

  describe "#processor_class" do
    it "resolves specified class" do
      stub_const("TestProcessor", Class.new(BaseProcessor))
      model.new(processor: "test")

      expect(model.new(processor: "test").processor_class).to eq(TestProcessor)
    end

    it { expect(model.new(processor: nil).processor_class).to be_nil }

    it { expect(model.new(processor: "missing").processor_class).to be_nil }
  end

  describe "#normalizer_class" do
    it "resolves specified class" do
      stub_const("TestNormalizer", Class.new(BaseNormalizer))
      model.new(normalizer: "test")

      expect(model.new(normalizer: "test").normalizer_class).to eq(TestNormalizer)
    end

    it { expect(model.new(normalizer: nil).normalizer_class).to be_nil }

    it { expect(model.new(normalizer: "missing").normalizer_class).to be_nil }
  end

  describe "#loader_instance" do
    it "instantiates a service" do
      stub_const("TestLoader", Class.new(BaseLoader))
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
      stub_const("TestProcessor", Class.new(BaseProcessor))
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

  describe "#service_classes" do
    it "returns a hash" do
      stub_const("TestLoader", Class.new(BaseLoader))
      stub_const("TestProcessor", Class.new(BaseProcessor))
      stub_const("TestNormalizer", Class.new(BaseNormalizer))
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
