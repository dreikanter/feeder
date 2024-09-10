RSpec.describe BaseNormalizer do
  subject(:normalizer) { described_class.new(feed_entity) }

  let(:feed_entity) { build(:feed_entity) }

  describe "#normalize" do
    it "raises an error" do
      expect { normalizer.normalize }.to raise_error(AbstractMethodError)
    end
  end

  describe "#uid" do
    it "raises an error" do
      expect { normalizer.uid }.to raise_error(AbstractMethodError)
    end
  end

  describe "#link" do
    it "raises an error" do
      expect { normalizer.link }.to raise_error(AbstractMethodError)
    end
  end

  describe "#published_at" do
    it "raises an error" do
      expect { normalizer.published_at }.to raise_error(AbstractMethodError)
    end
  end

  describe "#text" do
    it "raises an error" do
      expect { normalizer.text }.to raise_error(AbstractMethodError)
    end
  end

  describe "#attachments" do
    it "returns an empty array" do
      expect(normalizer.attachments).to eq([])
    end
  end

  describe "#comments" do
    it "returns an empty array" do
      expect(normalizer.comments).to eq([])
    end
  end

  describe "#validation_errors" do
    it "returns an empty array" do
      expect(normalizer.validation_errors).to eq([])
    end
  end

  describe "#validation_errors?" do
    context "when there are no validation errors" do
      it "returns false" do
        expect(normalizer.validation_errors?).to eq(false)
      end
    end

    context "when there are some validation errors" do
      subject(:normalizer) { test_normalizer.new(build(:feed_entity)) }

      let(:test_normalizer) do
        Class.new(BaseNormalizer) do
          def validation_errors
            ["sample validation error"]
          end
        end
      end

      it "returns true" do
        expect(normalizer.validation_errors?).to eq(true)
      end
    end
  end
end
