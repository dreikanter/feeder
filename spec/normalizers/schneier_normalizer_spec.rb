require "rails_helper"
require "support/shared_examples_a_normalizer"

RSpec.describe SchneierNormalizer do
  it_behaves_like "a normalizer" do
    let(:feed) do
      create(
        :feed,
        name: "schneier",
        url: "https://www.schneier.com/blog/atom.xml",
        loader: "http",
        processor: "atom",
        normalizer: "schneier"
      )
    end
  end
end
