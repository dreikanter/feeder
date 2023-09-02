require "rails_helper"
require "support/shared_examples_a_normalizer"

RSpec.describe RedditNormalizer do
  subject(:subject_name) { described_class }

  before do
    # Clear cache for RedditPointsFetcher
    Rails.cache.clear

    ServiceInstance.delete_all

    create(
      :service_instance,
      service_type: "libreddit",
      url: "https://libreddit.example.com"
    )

    # Stub RedditPointsFetcher requests
    stub_request(:get, %r{^https://libreddit.example.com/})
      .to_return(body: file_fixture("feeds/reddit/libreddit_comments_page.html"))
  end

  it_behaves_like "a normalizer" do
    let(:feed) do
      create(
        :feed,
        name: "reddit",
        url: "https://www.reddit.com/r/worldnews/.rss",
        loader: "http",
        processor: "reddit",
        normalizer: "reddit",
        import_limit: 10
      )
    end
  end
end
