require "rails_helper"
require "support/shared_examples_a_normalizer"

RSpec.describe InfiniteimmortalbensNormalizer do
  subject(:subject_name) { described_class }

  it_behaves_like "a normalizer" do
    let(:feed) do
      create(
        :feed,
        name: "infiniteimmortalbens",
        loader: "http",
        processor: "rss",
        normalizer: "infiniteimmortalbens",
        url: "https://infiniteimmortalbens.com/feed/",
        import_limit: 2
      )
    end

    let(:feed_fixture) { "feeds/infiniteimmortalbens/feed.xml" }
    let(:normalized_fixture) { "feeds/infiniteimmortalbens/normalized.json" }
  end
end
