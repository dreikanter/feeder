require "rails_helper"
require "support/shared_examples_a_normalizer"

RSpec.describe SmbcNormalizer do
  it_behaves_like "a normalizer" do
    let(:feed) do
      create(
        :feed,
        name: "smbc",
        url: "https://www.smbc-comics.com/comic/rss",
        loader: "http",
        processor: "rss",
        normalizer: "smbc"
      )
    end

    before do
      stub_request(:get, %r{^https://www.smbc-comics.com/comic/(?!rss)})
        .to_return(body: file_fixture("feeds/smbc/post.html").read)
    end
  end
end
