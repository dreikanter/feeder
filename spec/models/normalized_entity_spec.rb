require "rails_helper"

RSpec.describe NormalizedEntity do
  subject(:model) { described_class }

  let(:feed) { create(:feed, after: import_threshold) }
  let(:import_threshold) { 1.day.ago }
  let(:one_day) { 1.day.seconds.to_i }

  before { freeze_time }

  describe "#stale?" do
    it "returns false for recent timestamps" do
      expect(normalized_entry(published_at: one_day.seconds.ago)).not_to be_stale
    end

    it "returns true for old timestamps" do
      expect(normalized_entry(published_at: one_day.succ.seconds.ago)).to be_stale
    end

    it "returns false with undefined (default) timestamp" do
      expect(normalized_entry).not_to be_stale
    end

    def normalized_entry(attributes = {})
      model.new(feed_id: feed.id, **attributes)
    end
  end

  describe "#==" do
    it { expect(model.new).to eq(model.new) }
  end

  describe "#as_json" do
    let(:expected) do
      {
        "feed_id" => "FEED_ID",
        "uid" => "UID",
        "link" => "LINK",
        "published_at" => published_at.to_s,
        "text" => "TEST",
        "attachments" => ["https://example.com/image.jpg"],
        "comments" => ["I'm a comment"],
        "validation_errors" => []
      }
    end

    let(:instance) do
      model.new(
        feed_id: "FEED_ID",
        uid: "UID",
        link: "LINK",
        published_at: published_at.to_s,
        text: "TEST",
        attachments: ["https://example.com/image.jpg"],
        comments: ["I'm a comment"],
        validation_errors: []
      )
    end

    let(:published_at) { Time.current }

    it { expect(instance.as_json).to eq(expected) }
  end
end
