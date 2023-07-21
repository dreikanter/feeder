require "rails_helper"
require "support/shared_examples_a_normalizer"

RSpec.describe SchneierNormalizer do
  subject(:subject_name) { described_class }

  it_behaves_like "a normalizer" do
    let(:feed) do
      create(
        :feed,
        name: "schneier",
        url: "https://www.schneier.com/blog/atom.xml",
        loader: "http",
        processor: "atom",
        normalizer: "schneier",
        import_limit: 2
      )
    end
  end
end
