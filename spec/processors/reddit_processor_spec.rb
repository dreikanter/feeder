require "rails_helper"

RSpec.describe RedditProcessor do
  subject(:processor) { described_class }

  let(:content) { file_fixture("feeds/reddit/feed.xml").read }

  let(:feed) do
    build(
      :feed,
      url: "https://www.reddit.com/r/worldnews/.rss",
      loader: "http",
      processor: "reddit",
      normalizer: "reddit",
      import_limit: 0
    )
  end

  let(:expected_uids) { JSON.parse(file_fixture("feeds/reddit/expected_uids.json").read) }
  let(:thread_url) { %r{^https://.*/r/worldnews/comments/} }
  let(:thread_contents) { file_fixture("feeds/reddit/libreddit_comments_page.html").read }

  before do
    Rails.cache.clear
    ServiceInstance.delete_all
    create(:service_instance, service_type: "libreddit")
  end

  it "fetches reddit points" do
    stub_posts_score_request
    expect(feed_entities.map(&:uid)).to eq(expected_uids)
  end

  it "caches posts score to prevent repeating HTTP requests too soon" do
    stub = stub_posts_score_request
    feed_entities
    remove_request_stub(stub)
    expect { feed_entities }.not_to raise_error
  end

  it "expires cache" do
    travel_to(4.hours.ago) do
      stub = stub_posts_score_request
      feed_entities
      remove_request_stub(stub)
    end

    # NOTE: Attempt to fetch fresh data after cache expired
    expect { feed_entities }.to raise_error(WebMock::NetConnectNotAllowedError)
  end

  it "ignores posts on score service error" do
    stub_request(:get, thread_url).to_return(status: 404)
    expect(feed_entities).to be_empty
  end

  def feed_entities
    processor.new(content: content, feed: feed).process
  end

  def stub_posts_score_request
    stub_request(:get, thread_url).to_return(body: thread_contents)
  end
end
