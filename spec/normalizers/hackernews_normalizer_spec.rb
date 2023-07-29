require "rails_helper"
require "support/shared_examples_a_normalizer"
require "support/shared_hackernews_stubs"

RSpec.describe HackernewsNormalizer do
  include_context "with hackernews stubs"

  it_behaves_like "a normalizer" do
    let(:feed) do
      create(
        :feed,
        name: "hackernews",
        loader: "hackernews",
        processor: "hackernews",
        normalizer: "hackernews",
        url: "http://example.com"
      )
    end
  end
end
