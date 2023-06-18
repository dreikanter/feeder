require "rails_helper"

RSpec.describe KotakuLoader do
  subject(:loader) { described_class }

  let(:feed) { create(:feed, url: "https://kotaku.com/rss", loader: "kotaku") }
  let(:feed_posts) { feed.posts }

  before do
    stub_request(:get, feed.url)
      .to_return(body: file_fixture("feeds/kotaku/rss.xml").read)

    stub_request(:get, %r{^https://kotaku.com/.*-\d+$})
      .to_return(body: file_fixture("feeds/kotaku/post.html").read)
  end

  it "does experimental stuff" do
    loader.call(feed)
    expect(feed_posts.count).to eq(51)
    expect(feed_posts).to all be_ignored
  end
end
