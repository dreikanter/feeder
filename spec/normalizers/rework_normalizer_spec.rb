require "rails_helper"
require "support/shared_examples_a_normalizer"

RSpec.describe ReworkNormalizer do
  subject(:subject_name) { described_class }

  it_behaves_like "a normalizer" do
    let(:feed) do
      create(
        :feed,
        name: "rework",
        loader: "http",
        processor: "feedjira",
        normalizer: "rework",
        url: "https://feeds.transistor.fm/rework",
        import_limit: 2
      )
    end
  end
end
