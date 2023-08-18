require "rails_helper"
require "support/shared_examples_a_normalizer"

RSpec.describe TumblrNormalizer do
  it_behaves_like "a normalizer" do
    let(:feed) do
      create(
        :feed,
        name: "tumblr",
        loader: "http",
        processor: "rss",
        normalizer: "tumblr",
        url: "https://example.com/rss"
      )
    end
  end
end
