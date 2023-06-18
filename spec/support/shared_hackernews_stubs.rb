RSpec.shared_examples "hackernews stubs" do
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

  before do
    stub_beststories_request
    stub_story_requests
  end
end
