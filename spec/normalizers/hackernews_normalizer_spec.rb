require "rails_helper"
require "support/shared_hackernews_stubs"

RSpec.describe HackernewsNormalizer do
  subject(:normalizer) { described_class }

  let(:feed) { create(:feed, :hackernews) }

  let(:result) { entities.map { |entity| normalizer.call(entity) }.as_json }
  let(:entities) { HackernewsProcessor.new(content: content, feed: feed).process }
  let(:content) { HackernewsLoader.new(feed).content }

  let(:expected) do
    JSON.parse(file_fixture("feeds/hackernews/expected_normalizer_result.json").read).map do |data|
      data.merge("feed_id" => feed.id)
    end
  end

  include_context "with hackernews stubs"

  it "matches the expected result" do
    expect(result).to eq(expected)
  end
end
