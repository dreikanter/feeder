require "rails_helper"
require "support/shared_hackernews_stubs"

RSpec.describe HackernewsNormalizer do
  subject(:normalizer) { described_class }

  let(:feed) { create(:feed, loader: "hackernews", processor: "hackernews", normalizer: "hackernews", import_limit: 2) }

  let(:result) { entities.map { |entity| normalizer.call(entity) }.as_json }
  let(:entities) { HackernewsProcessor.call(content: content, feed: feed) }
  let(:content) { HackernewsLoader.call(feed) }

  let(:expected) do
    JSON.parse(file_fixture("feeds/hackernews/expected_normalizer_result.json").read).map do |data|
      data.merge("feed_id" => feed.id, "published_at" => DateTime.parse(data["published_at"]))
    end
  end

  include_context "with hackernews stubs"

  it "matches the expected result" do
    expect(result).to eq(expected)
  end
end
