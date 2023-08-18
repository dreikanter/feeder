require "rails_helper"
require "support/shared_examples_a_normalizer"

RSpec.describe NextbigfutureNormalizer do
  before do
    stub_request(:get, %r{^https://www.nextbigfuture.com/.*.html$})
      .to_return(body: file_fixture("feeds/nextbigfuture/post.html").read)
  end

  it_behaves_like "a normalizer" do
    let(:feed) do
      create(
        :feed,
        name: "nextbigfuture",
        url: "https://www.nextbigfuture.com/feed",
        loader: "http",
        processor: "feedjira",
        normalizer: "nextbigfuture"
      )
    end
  end
end
