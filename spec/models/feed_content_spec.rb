require "rails_helper"

RSpec.describe FeedContent do
  subject(:model) { described_class }

  describe "#initialize" do
    it "accepts attributes" do
      instance = model.new(
        content: "CONTENT",
        imported_at: "IMPORTED_AT",
        import_duration: "IMPORT_DURATION"
      )

      expect(instance.content).to eq("CONTENT")
      expect(instance.imported_at).to eq("IMPORTED_AT")
      expect(instance.import_duration).to eq("IMPORT_DURATION")
    end
  end

  describe "#==" do
    let(:time_now) { Time.current }
    let(:content) { "Sample content" }
    let(:duration) { 5 }

    let(:feed_content) do
      model.new(
        content: content,
        imported_at: time_now,
        import_duration: duration
      )
    end

    context "with identical attribute values" do
      let(:other_feed_content) do
        model.new(
          content: content,
          imported_at: time_now,
          import_duration: duration
        )
      end

      it { expect(feed_content == other_feed_content).to be(true) }
    end

    context "with different content" do
      let(:other_feed_content) do
        model.new(
          content: "DIFFERENT",
          imported_at: time_now,
          import_duration: duration
        )
      end

      it { expect(feed_content == other_feed_content).to be(false) }
    end

    context "with different imported_at" do
      let(:other_feed_content) do
        model.new(
          content: content,
          imported_at: time_now + 1,
          import_duration: duration
        )
      end

      it { expect(feed_content == other_feed_content).to be(false) }
    end

    context "with different import_duration" do
      let(:other_feed_content) do
        model.new(
          content: content,
          imported_at: time_now,
          import_duration: duration + 1
        )
      end

      it { expect(feed_content == other_feed_content).to be(false) }
    end

    context "when comparing with an object of different type" do
      it { expect(feed_content == "BANANA").to be(false) }
    end
  end
end
