require "rails_helper"
require "support/shared_examples_a_normalizer"

RSpec.describe OglafNormalizer do
  it_behaves_like "a normalizer" do
    let(:feed) do
      create(
        :feed,
        name: "oglaf",
        loader: "http",
        processor: "rss",
        normalizer: "oglaf",
        url: "https://feeds.feedburner.com/oatmealfeed"
      )
    end

    before do
      stub_request(:get, /www.oglaf.com/)
        .to_return(body: file_fixture("feeds/oglaf/post.html").read)
    end
  end
end
