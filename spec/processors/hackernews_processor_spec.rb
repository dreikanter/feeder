require "rails_helper"
require "support/shared_hackernews_stubs"

RSpec.describe HackernewsProcessor do
  subject(:processor) { described_class }

  let(:entities) { processor.new(content: content, feed: feed).entities }
  let(:feed) { create(:feed, :hackernews) }
  let(:content) { HackernewsLoader.new(feed).content }
  let(:expected_content) { JSON.parse(file_fixture("feeds/hackernews/expected_processor_result.json").read) }

  include_context "with hackernews stubs"

  it "returns entities" do
    expect(entities).to all be_a(FeedEntity)
  end

  it "references the feed" do
    expect(entities.map(&:feed)).to all eq(feed)
  end

  it "filters most recent entities" do
    expect(entities.map(&:uid)).to eq(%w[100005 100003 100001])
  end

  it "returns expected content" do
    expect(entities.map(&:content).as_json).to eq(9000)
  end
end
