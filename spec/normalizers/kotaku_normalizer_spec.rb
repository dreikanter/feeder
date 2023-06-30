require "rails_helper"

RSpec.describe KotakuNormalizer do
  subject(:normalizer) { described_class }

  let(:feed) { create(:feed, :kotaku) }
  let(:content) { feed.loader_class.call(feed) }
  let(:entities) { feed.processor_class.call(content: content, feed: feed) }
  let(:normalized_entries) { entities.map { |entity| normalizer.call(entity) } }

  let(:expected) do
    JSON.parse(file_fixture("feeds/kotaku/normalized.json").read).map do |data|
      data.merge(
        "feed_id" => feed.id,
        "published_at" => DateTime.parse(data["published_at"])
      )
    end
  end

  before do
    travel_to(DateTime.parse("2023-06-17 01:00:00 +0000"))

    stub_request(:get, feed.url)
      .to_return(body: file_fixture("feeds/kotaku/rss.xml").read)

    stub_request(:get, %r{^https://kotaku.com/.*-\d+$})
      .to_return(body: file_fixture("feeds/kotaku/post.html").read)
  end

  it "resolves" do
    expect(feed.normalizer_class).to eq(described_class)
  end

  it "returns expected result" do
    expect(normalized_entries.as_json).to eq(expected)
  end
end
