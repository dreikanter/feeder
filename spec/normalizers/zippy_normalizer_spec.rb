require "rails_helper"

RSpec.describe ZippyNormalizer do
  subject(:normalizer) { described_class }

  let(:feed) do
    create(
      :feed,
      name: "zippy",
      loader: "http",
      processor: "feedjira",
      normalizer: "zippy",
      url: "https://www.comicsrss.com/rss/zippy-the-pinhead.rss"
    )
  end

  let(:normalized_entries) { entities.map { normalizer.call(_1) } }
  let(:entities) { feed.processor_class.call(content: content, feed: feed) }
  let(:content) { feed.loader_class.call(feed) }

  let(:expected) do
    JSON.parse(file_fixture("feeds/zippy/normalized.json").read).map do |data|
      data.merge("feed_id" => feed.id)
    end
  end

  before do
    Feed.delete_all

    travel_to(DateTime.parse("2023-06-17 01:00:00 +0000"))

    stub_request(:get, feed.url)
      .to_return(body: file_fixture("feeds/zippy/feed.xml").read)
  end

  it "resolves" do
    expect(feed.normalizer_class).to eq(described_class)
  end

  it "returns expected result" do
    expect(normalized_entries.as_json).to eq(expected)
  end
end
