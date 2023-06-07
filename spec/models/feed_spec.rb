require "rails_helper"

RSpec.describe Feed do
  let(:one_day_in_seconds) { 1.day.seconds.to_i }
  let(:stale_timestampt) { (one_day_in_seconds.succ).seconds.ago }
  let(:recent_timestampt) { (one_day_in_seconds.pred).seconds.ago }
  let(:stale_feeds_scope) { described_class.stale }

  around(:example) { |example| freeze_time { example.run } }

  it "should be valid" do
    expect(build(:feed)).to be_valid
  end

  it "should require name" do
    feed = build(:feed, name: nil)
    expect(feed).not_to be_valid
    expect(feed.errors).to include(:name)
  end

  it "should init refresh interval with a default" do
    expect(described_class.new.refresh_interval).to be_zero
  end

  it "whould not init import limit with a default" do
    expect(described_class.new.import_limit).to be_nil
  end

  describe "stale" do
    it "should init treat new feed as stale" do
      expect(described_class.new).to be_stale
    end

    it "should evaluate stale condition" do
      refreshed_at = (one_day_in_seconds.succ).seconds.ago
      feed = build(:feed, refresh_interval: one_day_in_seconds, refreshed_at: stale_timestampt)
      expect(feed).to be_stale
    end

    it "should scope stale feeds" do
      expect {
        create(:feed, refresh_interval: one_day_in_seconds, refreshed_at: stale_timestampt)
      }.to change { stale_feeds_scope.count }.by(1)
    end

    it "should treat records with zero refresh interval as always stale" do
      feed = create(:feed, refresh_interval: 0, refreshed_at: Time.current)
      expect(feed).to be_stale
      expect(stale_feeds_scope.where(id: feed.id)).to exist
    end

    it "should treat records with undefined refresh timestamp as stale" do
      feed = create(:feed, refresh_interval: 0, refreshed_at: nil)
      expect(feed).to be_stale
      expect(stale_feeds_scope.where(id: feed.id)).to exist
    end

    it "should treat records with recent refresh timestamp as not stale" do
      feed = create(:feed, refresh_interval: one_day_in_seconds, refreshed_at: recent_timestampt)
      expect(feed).not_to be_stale
      expect(stale_feeds_scope.where(id: feed.id)).not_to exist
    end
  end
end
