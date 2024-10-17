RSpec.describe Feed do
  describe "relations" do
    subject(:feed) { build(:feed) }

    it { expect(feed).to have_many(:posts) }
    it { expect(feed).to have_many(:error_reports) }
  end

  describe "validations" do
    subject(:feed) { build(:feed) }

    it "is valid with valid attributes" do
      expect(feed).to be_valid
    end

    describe "#name" do
      it "validates presence" do
        expect(feed).to validate_presence_of(:name)
      end

      it "validates length" do
        expect(feed).to validate_length_of(:name).is_at_least(3).is_at_most(80)
      end

      it "allows valid names" do
        expect(feed).to allow_value("valid-name123").for(:name)
      end

      it "disallows invalid names" do
        expect(feed).not_to allow_value("invalid name").for(:name)
        expect(feed).not_to allow_value("invalid@name").for(:name)
      end
    end

    describe "#name normalization" do
      it "normalizes" do
        feed = build(:feed, name: "  TestName  ")

        expect(feed.name).to eq("testname")
      end
    end

    describe "#import_limit" do
      it "validates numericality" do
        expect(feed).to validate_numericality_of(:import_limit).is_less_than_or_equal_to(Feed::MAX_LIMIT_LIMIT)
      end
    end

    describe "#refresh_interval" do
      it "validates presence" do
        expect(feed).to validate_presence_of(:refresh_interval)
      end

      it "validates numericality" do
        expect(feed).to validate_numericality_of(:refresh_interval).is_greater_than_or_equal_to(0)
      end
    end

    %i[loader normalizer processor].each do |attribute|
      describe "##{attribute}" do
        it "validates presence" do
          expect(feed).to validate_presence_of(attribute)
        end

        it "allows valid names" do
          expect(feed).to allow_value("ValidName").for(attribute)
        end

        it "disallows invalid names" do
          expect(feed).not_to allow_value("Invalid Name").for(attribute)
        end
      end
    end

    describe "#url" do
      it "allows nil" do
        expect(feed).to allow_value(nil).for(:url)
      end

      it "validates length" do
        expect(feed).to validate_length_of(:url).is_at_most(Feed::MAX_URL_LENGTH).allow_nil
      end
    end

    describe "#source_url" do
      it "allows blank" do
        expect(feed).to allow_value("").for(:source_url)
      end

      it "validates length" do
        expect(feed).to validate_length_of(:source_url).is_at_most(Feed::MAX_URL_LENGTH).allow_blank
      end
    end

    describe "#description" do
      it "allows blank" do
        expect(feed).to allow_value("").for(:description)
      end

      it "validates length" do
        expect(feed).to validate_length_of(:description).is_at_most(Feed::MAX_DESCRIPTION_LENGTH).allow_blank
      end
    end

    describe "#disabling_reason" do
      it "allows blank" do
        expect(feed).to allow_value("").for(:disabling_reason)
      end

      it "validates length" do
        expect(feed).to validate_length_of(:disabling_reason).is_at_most(Feed::MAX_DESCRIPTION_LENGTH).allow_blank
      end
    end

    describe "#options" do
      it "is valid with hash" do
        feed = build(:feed, options: {key: "value"})

        expect(feed).to be_valid
      end

      it "is invalid with non-hash" do
        feed = build(:feed, options: "not a hash")

        expect(feed).not_to be_valid
        expect(feed.errors[:options]).to include("must be a hash")
      end
    end
  end

  describe "#configurable?" do
    let(:arbitrary_time) { Time.current }

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

  describe "#reference" do
    it "returns expected value" do
      actual = build(:feed, id: 1, name: "sample").reference

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
