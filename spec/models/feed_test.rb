require "rails_helper"

RSpec.describe Feed do
  subject(:model) { described_class }

  let(:blank_feed) { model.new }
  let(:refresh_interval) { 1.day.seconds.to_i }
  let(:stale_feed) { create(:feed, refresh_interval: refresh_interval, refreshed_at: refresh_interval.succ.seconds.ago) }
  let(:non_stale_feed) { create(:feed, refresh_interval: refresh_interval, refreshed_at: refresh_interval.pred.seconds.ago) }

  before { freeze_time }

  it "validates" do
    expect(model.new(name: "sample")).to be_valid
  end

  it "requires name" do
    expect(blank_feed).not_to be_valid
    expect(blank_feed.errors).to include "name"
  end

  it "defines default refresh interval" do
    expect(blank_feed.refresh_interval).to be_zero
  end

  it "treats new feed as stale" do
    expect(blank_feed).to be_stale
  end

  it "evaluates stale condition" do
    expect(stale_feed).to be_stale
    expect(non_stale_feed).not_to be_stale
  end

  it "scopes stale feeds" do
    expect(Feed.stale.where(id: stale_feed.id)).to exist
  end

  it "treats feeds with zero refresh interval as always stale" do
    feed = create(:feed, refresh_interval: 0, refreshed_at: Time.current)
    expect(feed).to be_stale
  end

  it "includes feeds with zero refresh interval to stale scope" do
    feed = create(:feed, refresh_interval: 0, refreshed_at: Time.current)
    expect(Feed.stale.where(id: feed.id)).to exist
  end

  it "treats feeds with undefined refreshed_at as stale" do
    feed = create(:feed, refresh_interval: refresh_interval, refreshed_at: nil)
    expect(feed).to be_stale
  end

  it "includes feeds with undefined refreshed_at to stale scope" do
    feed = create(:feed, refresh_interval: refresh_interval, refreshed_at: nil)
    expect(Feed.stale.where(id: feed.id)).to exist
  end

  it "has no default import limit" do
    expect(blank_feed.import_limit).to be_nil
  end
end
