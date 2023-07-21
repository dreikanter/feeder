require "rails_helper"
require "support/shared_examples_a_normalizer"

RSpec.describe LunarbaboonNormalizer do
  subject(:subject_name) { described_class }

  it_behaves_like "a normalizer" do
    let(:feed) do
      create(
        :feed,
        name: "lunarbaboon",
        loader: "http",
        processor: "feedjira",
        normalizer: "lunarbaboon",
        url: "http://www.lunarbaboon.com/comics/rss.xml"
      )
    end

    let(:feed_fixture) { "feeds/lunarbaboon/feed.xml" }
    let(:normalized_fixture) { "feeds/lunarbaboon/normalized.json" }
  end
end
