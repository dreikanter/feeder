require "rails_helper"

RSpec.describe Feed do
  subject(:model) { described_class }

  let(:one_day) { 1.day.seconds.to_i }
  let(:stale_timestampt) { one_day.succ.seconds.ago }
  let(:recent_timestampt) { one_day.pred.seconds.ago }
  let(:stale_feeds_scope) { described_class.stale }

  before { freeze_time }

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
      described_class.delete_all
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
      feed = build(:feed, refresh_interval: one_day, refreshed_at: stale_timestampt)
      expect(feed).to be_stale
    end

    it "scopes stale feeds" do
      expect do
        create(:feed, refresh_interval: one_day, refreshed_at: stale_timestampt)
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
      feed = create(:feed, refresh_interval: one_day, refreshed_at: recent_timestampt)
      expect(feed).not_to be_stale
      expect(stale_feeds_scope.where(id: feed.id)).not_to exist
    end
  end

  describe "#loader_class" do
    it "resolves specified class" do
      expect(build(:feed, loader: "null").loader_class).to eq(NullLoader)
    end

    it "resolves default class" do
      expect(build(:feed, loader: nil).loader_class).to eq(HttpLoader)
    end

    it "raises when can't resolve the class" do
      expect { build(:feed, loader: "missing").loader_class }.to raise_error(LoaderResolver::Error)
    end
  end

  describe "#processor_class" do
    it "resolves specified class" do
      expect(build(:feed, processor: "rss").processor_class).to eq(RssProcessor)
    end

    it "fallbacks to default when processor is undefined" do
      expect(build(:feed, processor: nil).processor_class).to eq(NullProcessor)
    end

    it "fallbacks to default when processor is missing" do
      expect(build(:feed, processor: "missing").processor_class).to eq(NullProcessor)
    end
  end

  describe "#normalizer_class" do
    it "resolves specified class" do
      expect(build(:feed, normalizer: "rss").normalizer_class).to eq(RssNormalizer)
    end

    it "raises when normalizer is not defined" do
      expect { build(:feed, normalizer: nil).normalizer_class }.to raise_error(RuntimeError)
    end

    it "raises when can't resolve the class" do
      expect { build(:feed, normalizer: "missing").normalizer_class }.to raise_error(RuntimeError)
    end
  end
end
