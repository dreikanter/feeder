require "rails_helper"
require "support/shared_examples_a_normalizer"

RSpec.describe XkcdNormalizer do
  subject(:subject_name) { described_class }

  it_behaves_like "a normalizer" do
    let(:feed) do
      create(
        :feed,
        name: "xkcd",
        loader: "http",
        processor: "rss",
        normalizer: "xkcd",
        url: "https://xkcd.com/rss.xml"
      )
    end

    let(:feed_fixture) { "feeds/xkcd/feed.xml" }
    let(:normalized_fixture) { "feeds/xkcd/normalized.json" }

    before do
      stub_request(:get, %r{//xkcd.com/\d+})
        .to_return(body: file_fixture("feeds/xkcd/post.html").read)
    end
  end
end
