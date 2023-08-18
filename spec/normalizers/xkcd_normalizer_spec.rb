require "rails_helper"
require "support/shared_examples_a_normalizer"

RSpec.describe XkcdNormalizer do
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

    before do
      stub_request(:get, %r{//xkcd.com/\d+})
        .to_return(body: file_fixture("feeds/xkcd/post.html").read)
    end
  end
end
