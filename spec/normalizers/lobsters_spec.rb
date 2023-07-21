require "rails_helper"
require "support/shared_examples_a_normalizer"

RSpec.describe LobstersNormalizer do
  subject(:subject_name) { described_class }

  it_behaves_like "a normalizer" do
    let(:feed) do
      create(
        :feed,
        name: "lobsters-ruby",
        loader: "http",
        processor: "lobsters",
        normalizer: "lobsters",
        url: "https://lobste.rs/t/ruby.rss"
      )
    end

    let(:feed_fixture) { "feeds/lobsters/feed.xml" }
    let(:normalized_fixture) { "feeds/lobsters/normalized.json" }
  end
end
