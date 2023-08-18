require "rails_helper"
require "support/shared_examples_a_normalizer"

RSpec.describe ZippyNormalizer do
  it_behaves_like "a normalizer" do
    let(:feed) do
      create(
        :feed,
        name: "zippy",
        loader: "http",
        processor: "feedjira",
        normalizer: "zippy",
        url: "https://www.comicsrss.com/rss/zippy-the-pinhead.rss"
      )
    end
  end
end
