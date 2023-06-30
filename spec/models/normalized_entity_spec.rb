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
end