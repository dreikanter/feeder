require "rails_helper"

RSpec.describe HackernewsNormalizer do
  subject(:normalizer) { described_class }

  let(:feed) { create(:feed, loader: "hackernews", processor: "hackernews", normalizer: "hackernews") }

  let(:result) { entities.map { |entity| normalizer.call(entity) }.as_json }
  let(:entities) { HackernewsProcessor.call(content, feed: feed, import_limit: 2) }
  let(:content) { HackernewsLoader.call(feed) }

  let(:expected) do
    JSON.parse(file_fixture("feeds/hackernews/expected_normalizer_result.json").read).map do |data|
      data.merge("feed_id" => feed.id, "published_at" => DateTime.parse(data["published_at"]))
    end
  end

  before do
    stub_request(:get, "https://hacker-news.firebaseio.com/v0/beststories.json")
      .to_return(body: file_fixture("feeds/hackernews/beststories.json").read)

    stub_request(:get, %r{^https://hacker-news\.firebaseio\.com/v0/item/\d+\.json$})
      .to_return do |request|
        {
          body: file_fixture(File.join("feeds/hackernews", File.basename(request.uri.path))).read
        }
      end
  end

  it "matches the expected result" do
    expect(result).to eq(expected)
  end
end
