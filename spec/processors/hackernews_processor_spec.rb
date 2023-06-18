require "rails_helper"

RSpec.describe HackernewsProcessor do
  subject(:processor) { described_class }

  let(:entities) { processor.call(content, feed: feed, import_limit: 2) }
  let(:feed) { create(:feed, loader: "hackernews", processor: "hackernews") }
  let(:content) { HackernewsLoader.call(feed) }
  let(:expected_content) { JSON.parse(file_fixture("feeds/hackernews/expected_processor_result.json").read) }

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

  it "references the feed" do
    expect(entities.map(&:feed)).to all eq(feed)
  end

  it "filters most recent entities" do
    expect(entities.map(&:uid)).to eq([100005, 100003])
  end

  it "returns expected content" do
    expect(entities.map(&:content).as_json).to eq(expected_content)
  end
end
