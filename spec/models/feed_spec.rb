require "rails_helper"

RSpec.describe Feed do
  let(:arbitrary_time) { Time.current }

  # TBD
  # describe "validations" do
  # end

  describe "#configurable?" do
    context "with missing timestamps" do
      it "returns true" do
        expect(build(:feed, updated_at: arbitrary_time, configured_at: nil)).to be_configurable
        expect(build(:feed, updated_at: true, configured_at: arbitrary_time)).to be_configurable
        expect(build(:feed, updated_at: nil, configured_at: nil)).to be_configurable
      end
    end

    context "when last update was before or during previous configuration" do
      it "returns true" do
        expect(build(:feed, updated_at: arbitrary_time, configured_at: arbitrary_time)).to be_configurable
        expect(build(:feed, updated_at: arbitrary_time - 1.second, configured_at: arbitrary_time)).to be_configurable
      end
    end

    context "when last update was manual" do
      it "returns false" do
        expect(build(:feed, updated_at: arbitrary_time + 1.second, configured_at: arbitrary_time)).not_to be_configurable
      end
    end
  end

  describe "#readable_id" do
    it "returns expected value" do
      actual = build(:feed, id: 1, name: "sample").readable_id

      expect(actual).to eq("feed-1-sample")
    end
  end

  describe "#ensure_supported" do
    context "with missing loader" do
      it "raises an error" do
        stub_const("TestProcessor", Class.new)
        stub_const("TestNormalizer", Class.new)
        feed = build(:feed, loader: "missing", processor: "test", normalizer: "test")

        expect { feed.ensure_supported }.to raise_error(FeedConfigurationError)
      end
    end

    context "with missing processor" do
      it "raises an error" do
        stub_const("TestProcessor", Class.new)
        stub_const("TestLoader", Class.new)
        feed = build(:feed, loader: "test", processor: "missing", normalizer: "test")

        expect { feed.ensure_supported }.to raise_error(FeedConfigurationError)
      end
    end

    context "with missing normalizer" do
      it "raises an error" do
        stub_const("TestProcessor", Class.new)
        stub_const("TestNormalizer", Class.new)
        feed = build(:feed, loader: "test", processor: "test", normalizer: "missing")

        expect { feed.ensure_supported }.to raise_error(FeedConfigurationError)
      end
    end

    context "with existing processing classes" do
      it "returns true" do
        stub_const("TestLoader", Class.new)
        stub_const("TestProcessor", Class.new)
        stub_const("TestNormalizer", Class.new)
        feed = build(:feed, loader: "test", processor: "test", normalizer: "test")

        expect(feed.ensure_supported).to be(true)
      end
    end
  end

  describe "#loader_class" do
    it "resolves specified class" do
      stub_const("TestLoader", Class.new(BaseLoader))
      feed = build(:feed, loader: "test")

      expect(feed.loader_class).to eq(TestLoader)
    end

    it { expect(build(:feed, processor: nil).loader_class).to be_nil }

    it { expect(build(:feed, processor: "missing").loader_class).to be_nil }
  end

  describe "#processor_class" do
    it "resolves specified class" do
      stub_const("TestProcessor", Class.new(BaseProcessor))
      build(:feed, processor: "test")

      expect(build(:feed, processor: "test").processor_class).to eq(TestProcessor)
    end

    it { expect(build(:feed, processor: nil).processor_class).to be_nil }

    it { expect(build(:feed, processor: "missing").processor_class).to be_nil }
  end

  describe "#normalizer_class" do
    it "resolves specified class" do
      stub_const("TestNormalizer", Class.new(BaseNormalizer))
      build(:feed, normalizer: "test")

      expect(build(:feed, normalizer: "test").normalizer_class).to eq(TestNormalizer)
    end

    it { expect(build(:feed, normalizer: nil).normalizer_class).to be_nil }

    it { expect(build(:feed, normalizer: "missing").normalizer_class).to be_nil }
  end

  describe "#loader_instance" do
    it "instantiates a service" do
      stub_const("TestLoader", Class.new(BaseLoader))
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
      stub_const("TestProcessor", Class.new(BaseProcessor))
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

  describe "#service_classes" do
    it "returns a hash" do
      stub_const("TestLoader", Class.new(BaseLoader))
      stub_const("TestProcessor", Class.new(BaseProcessor))
      stub_const("TestNormalizer", Class.new(BaseNormalizer))
      feed = build(:feed, loader: "test", processor: "test", normalizer: "test")

      expected = {
        loader_class: TestLoader,
        processor_class: TestProcessor,
        normalizer_class: TestNormalizer
      }

      expect(feed.service_classes).to eq(expected)
    end

    it "tolerates missing service classes" do
      feed = build(:feed, loader: "test", processor: "test", normalizer: "test")

      expected = {
        loader_class: nil,
        processor_class: nil,
        normalizer_class: nil
      }

      expect(feed.service_classes).to eq(expected)
    end
  end
end
