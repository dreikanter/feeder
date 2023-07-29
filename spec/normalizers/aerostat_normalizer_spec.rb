require "rails_helper"
require "support/shared_examples_a_normalizer"

RSpec.describe AerostatNormalizer do
  it_behaves_like "a normalizer" do
    let(:feed) do
      create(
        :feed,
        name: "aerostat",
        loader: "http",
        processor: "feedjira",
        normalizer: "aerostat",
        url: "http://example.com",
        import_limit: 0
      )
    end
  end
end
