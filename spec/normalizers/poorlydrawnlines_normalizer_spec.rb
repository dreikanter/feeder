require "rails_helper"
require "support/shared_examples_a_normalizer"

RSpec.describe PoorlydrawnlinesNormalizer do
  subject(:subject_name) { described_class }

  it_behaves_like "a normalizer" do
    let(:feed) do
      create(
        :feed,
        name: "poorlydrawnlines",
        url: "https://feeds.feedburner.com/PoorlyDrawnLines",
        loader: "http",
        processor: "feedjira",
        normalizer: "poorlydrawnlines"
      )
    end
  end
end
