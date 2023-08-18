require "rails_helper"
require "support/shared_examples_a_normalizer"

RSpec.describe TheAtlanticPhotosNormalizer do
  it_behaves_like "a normalizer" do
    let(:feed) do
      create(
        :feed,
        name: "the-atlantic-photos",
        url: "https://feeds.feedburner.com/theatlantic/infocus",
        loader: "http",
        processor: "rss",
        normalizer: "the_atlantic_photos"
      )
    end

    before do
      stub_request(:get, %r{^http://feedproxy.google.com/~r/theatlantic/infocus/.*})
        .to_return(body: "")
    end
  end
end
