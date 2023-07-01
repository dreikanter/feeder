require "rails_helper"

RSpec.describe BaseNormalizer do
  subject(:normalizer) { described_class }

  let(:feed) { build(:feed) }
  let(:entity) { FeedEntity.new(uid: "UID", content: "CONTENT", feed: feed) }
  let(:sample_errors) { ["sample error"] }

  context "with basic concrete normalizer" do
    let(:concrete_normalizer) { Class.new(subject) }

    it "returns normalized entity" do
      expect(concrete_normalizer.call(entity)).to be_a(NormalizedEntity)
    end
  end

  context "with non-valid entity" do
    let(:concrete_normalizer) do
      Class.new(subject) do
        define_method(:validation_errors) { ["ERROR"] }
      end
    end

    it "returns normalized entity with validation errors" do
      expect(concrete_normalizer.call(entity).validation_errors).to eq(["ERROR"])
    end
  end

  context "with messy or blank attachment URLs" do
    let(:concrete_normalizer) do
      Class.new(subject) do
        define_method(:attachments) { ["//example.com", "", nil] }
      end
    end

    it "sanitizes attachment URLs" do
      expect(concrete_normalizer.call(entity).attachments).to eq(["https://example.com"])
    end
  end

  context "when #attachments return non-valid URLs" do
    let(:concrete_normalizer) do
      Class.new(subject) do
        define_method(:attachments) { [":"] }
      end
    end

    it "raises an error" do
      expect { concrete_normalizer.call(entity) }.to raise_error(StandardError)
    end
  end

  context "when #attachments return non-array object" do
    let(:concrete_normalizer) do
      Class.new(subject) do
        define_method(:attachments) { nil }
      end
    end

    it "raises an error" do
      expect { concrete_normalizer.call(entity) }.to raise_error(StandardError)
    end
  end

  context "when #comments return non-array object" do
    let(:concrete_normalizer) do
      Class.new(subject) do
        define_method(:comments) { nil }
      end
    end

    it "raises an error" do
      expect { concrete_normalizer.call(entity) }.to raise_error(StandardError)
    end
  end

  context "with blank comments" do
    let(:concrete_normalizer) do
      Class.new(subject) do
        define_method(:comments) { [nil, ""] }
      end
    end

    it "skips blank comments" do
      expect(concrete_normalizer.call(entity).comments).to be_blank
    end
  end
end
