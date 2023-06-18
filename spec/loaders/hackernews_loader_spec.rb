require "rails_helper"

RSpec.describe HackernewsLoader do
  subject(:loader) { described_class }

  let(:feed) { create(:feed, loader: "hackernews") }

  let(:expected) { JSON.parse(file_fixture("feeds/hackernews/expected_loader_result.json").read) }

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

  it "fetches data" do
    expect(loader.call(feed)).to eq(expected)
  end
end
