require "rails_helper"
require "support/shared_examples_a_normalizer"

RSpec.describe OatmealNormalizer do
  subject(:subject_name) { described_class }

  it_behaves_like "a normalizer" do
    let(:feed) do
      create(
        :feed,
        name: "oatmeal",
        loader: "http",
        processor: "rss",
        normalizer: "oatmeal",
        url: "https://feeds.feedburner.com/oatmealfeed"
      )
    end
  end
end
