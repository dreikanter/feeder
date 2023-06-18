require "rails_helper"

RSpec.describe HackernewsProcessor do
  subject(:processor) { described_class }

  let(:entities) { processor.call(content, feed: feed, import_limit: 2) }
  let(:feed) { create(:feed, loader: "hackernews", processor: "hackernews") }
  let(:content) { HackernewsLoader.call(feed) }

  let(:expected_content) do
    {
      "by" => "username",
      "descendants" => 1047,
      "id" => 36346254,
      "kids" => [36351647, 36351293, 36353753],
      "score" => 1738,
      "time" => 1686887333,
      "title" => "Sample title",
      "type" => "story",
      "url" => "https://example.com/"
    }
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

  it "returns entities" do
    expect(entities).to all be_a(Entity)
  end

  it "returns entity feed" do
    expect(entities.first.feed).to eq(feed)
  end

  it "returns most recent entity uids based" do
    expect(entities.map(&:uid)).to eq([36346254, 36350938])
  end

  it "processes content" do
    expect(entities.first.content).to eq(expected_content)
  end
end
