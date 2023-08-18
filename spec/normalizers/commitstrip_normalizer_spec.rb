require "rails_helper"
require "support/shared_examples_a_normalizer"

RSpec.describe CommitstripNormalizer do
  it_behaves_like "a normalizer" do
    let(:feed) do
      create(
        :feed,
        name: "commitstrip",
        url: "https://www.commitstrip.com/en/feed/",
        loader: "http",
        processor: "feedjira",
        normalizer: "commitstrip"
      )
    end
  end
end
