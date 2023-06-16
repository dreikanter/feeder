require "rails_helper"

RSpec.describe Feed do
  let(:one_day_in_seconds) { 1.day.seconds.to_i }
  let(:stale_timestampt) { one_day_in_seconds.succ.seconds.ago }
  let(:recent_timestampt) { one_day_in_seconds.pred.seconds.ago }
  let(:stale_feeds_scope) { described_class.stale }

  around { |example| freeze_time { example.run } }

  describe "validation" do
    it "is valid" do
      expect(build(:feed)).to be_valid
    end

    it "requires name" do
      feed = build(:feed, name: nil)
      expect(feed).not_to be_valid
      expect(feed.errors).to include(:name)
    end
  end

  describe "initialization" do
    it "inits refresh interval with a default" do
      expect(described_class.new.refresh_interval).to be_zero
    end

    it "whould not init import limit with a default" do
      expect(described_class.new.import_limit).to be_nil
    end
  end

  describe "state" do
    let(:enabled_feed) { create(:feed, state: "enabled") }
    let(:disabled_feed) { create(:feed, state: "disabled") }
    let(:paused_feed) { create(:feed, state: "paused") }

    it "updates timestamp on enable" do
      expect { disabled_feed.enable! }.to(change(disabled_feed, :state_updated_at).from(nil).to(Time.current))
    end

    it "updates timestamp on disable" do
      expect { enabled_feed.disable! }.to(change(enabled_feed, :state_updated_at).from(nil).to(Time.current))
    end

    it "keeps timestamp on pause" do
      expect { enabled_feed.pause! }.not_to change(enabled_feed, :state_updated_at)
    end

    it "keeps timestamp on unpause" do
      expect { paused_feed.unpause! }.not_to change(paused_feed, :state_updated_at)
    end
  end

  describe "staling" do
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
