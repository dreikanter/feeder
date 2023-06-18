require "rails_helper"

RSpec.describe HackernewsLoader do
  subject(:loader) { described_class }

  let(:feed) { create(:feed, loader: "hackernews") }

  let(:stub_beststories_request) do
    stub_request(:get, "https://hacker-news.firebaseio.com/v0/beststories.json")
      .to_return(body: file_fixture("feeds/hackernews/beststories.json").read)
  end

  let(:stub_story_requests) do
    stub_request(:get, %r{^https://hacker-news\.firebaseio\.com/v0/item/\d+\.json$})
      .to_return do |request|
        {
          body: file_fixture(File.join("feeds/hackernews", File.basename(request.uri.path))).read
        }
      end
  end

  let(:expected) { JSON.parse(file_fixture("feeds/hackernews/expected_loader_result.json").read) }

  before do
    stub_beststories_request
    stub_story_requests
  end

  it "fetches stories" do
    expect(loader.call(feed)).to eq(expected)
  end

  it "caches stories" do
    freeze_time do
      # The first load caches the sories
      loader.call(feed)

      remove_request_stub(stub_story_requests)

      # Repeating load to see if it will attempt to repeat loading sories,
      # causing WebMock to raise after the stub removal
      expect { loader.call(feed) }.not_to raise_error
    end
  end
end
