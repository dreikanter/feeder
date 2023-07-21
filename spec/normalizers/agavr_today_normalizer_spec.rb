require "rails_helper"
require "support/shared_examples_a_normalizer"

RSpec.describe AgavrTodayNormalizer do
  subject(:subject_name) { described_class }

  it_behaves_like "a normalizer" do
    let(:feed) do
      create(
        :feed,
        name: "agavr-today",
        loader: "http",
        processor: "rss",
        normalizer: "agavr_today",
        url: "https://tele.ga/agavr_today/rss/"
      )
    end

    let(:feed_fixture) { "feeds/agavr_today/feed.xml" }
    let(:normalized_fixture) { "feeds/agavr_today/normalized.json" }
  end
end
