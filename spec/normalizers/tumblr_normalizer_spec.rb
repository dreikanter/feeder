require "rails_helper"
require "support/shared_examples_a_normalizer"

RSpec.describe TumblrNormalizer do
  it_behaves_like "a normalizer" do
    let(:feed) do
      create(
        :feed,
        name: "zippy",
        loader: "http",
        processor: "rss",
        normalizer: "tumblr",
        url: "https://kimchicuddles.com/rss"
      )
    end

    let(:feed_fixture) { "feeds/tumblr/feed.xml" }
    let(:normalized_fixture) { "feeds/tumblr/entity.json" }
  end
end
