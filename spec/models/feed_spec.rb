require "rails_helper"

RSpec.describe Feed do
  let(:one_day_in_seconds) { 1.day.seconds.to_i }
  let(:stale_timestampt) { one_day_in_seconds.succ.seconds.ago }
  let(:recent_timestampt) { one_day_in_seconds.pred.seconds.ago }
  let(:stale_feeds_scope) { described_class.stale }

  around { |example| freeze_time { example.run } }

  it "is valid" do
    expect(build(:feed)).to be_valid
  end

  it "requires name" do
    feed = build(:feed, name: nil)
    expect(feed).not_to be_valid
    expect(feed.errors).to include(:name)
  end

  it "inits refresh interval with a default" do
    expect(described_class.new.refresh_interval).to be_zero
  end

  it "whould not init import limit with a default" do
    expect(described_class.new.import_limit).to be_nil
  end

  describe "ordered_by" do
    let(:sample_timestamps) do
      [
        DateTime.parse("2023-06-16 02:00:00 +0000"),
        DateTime.parse("2023-06-16 01:00:00 +0000"),
        DateTime.parse("2023-06-16 00:00:00 +0000")
      ]
    end

    let(:feed_with_no_refreshed_at) { create(:feed, refreshed_at: nil) }

    before do
      sample_timestamps.each { |timestamp| create(:feed, refreshed_at: timestamp) }
    end

    it "orders records" do
      timestamps = ordered_by_refreshed_at(:desc).pluck(:refreshed_at)
      expect(timestamps).to eq(sample_timestamps.sort.reverse)
    end

    it "keeps null last during desc ordering" do
      feed_with_no_refreshed_at
      last_feed_id = ordered_by_refreshed_at(:desc).pluck(:id).last
      expect(last_feed_id).to eq(feed_with_no_refreshed_at.id)
    end

    it "keeps null last during asc ordering" do
      feed_with_no_refreshed_at
      last_feed_id = ordered_by_refreshed_at(:asc).pluck(:id).last
      expect(last_feed_id).to eq(feed_with_no_refreshed_at.id)
    end

    def ordered_by_refreshed_at(direction)
      described_class.ordered_by(:refreshed_at, direction)
    end
  end

  describe "stale" do
    it "inits treat new feed as stale" do
      expect(described_class.new).to be_stale
    end

    it "evaluates stale condition" do
      feed = build(:feed, refresh_interval: one_day_in_seconds, refreshed_at: stale_timestampt)
      expect(feed).to be_stale
    end

    it "scopes stale feeds" do
      expect do
        create(:feed, refresh_interval: one_day_in_seconds, refreshed_at: stale_timestampt)
      end.to change(stale_feeds_scope, :count).by(1)
    end

    it "treats records with zero refresh interval as always stale" do
      feed = create(:feed, refresh_interval: 0, refreshed_at: Time.current)
      expect(feed).to be_stale
      expect(stale_feeds_scope.where(id: feed.id)).to exist
    end

    it "treats records with undefined refresh timestamp as stale" do
      feed = create(:feed, refresh_interval: 0, refreshed_at: nil)
      expect(feed).to be_stale
      expect(stale_feeds_scope.where(id: feed.id)).to exist
    end

    it "treats records with recent refresh timestamp as not stale" do
      feed = create(:feed, refresh_interval: one_day_in_seconds, refreshed_at: recent_timestampt)
      expect(feed).not_to be_stale
      expect(stale_feeds_scope.where(id: feed.id)).not_to exist
    end
  end
end
