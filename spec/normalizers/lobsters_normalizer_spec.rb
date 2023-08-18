require "rails_helper"
require "support/shared_examples_a_normalizer"

RSpec.describe LobstersNormalizer do
  it_behaves_like "a normalizer" do
    let(:feed) do
      create(
        :feed,
        name: "lobsters",
        loader: "http",
        processor: "lobsters",
        normalizer: "lobsters",
        url: "https://lobste.rs/t/ruby.rss"
      )
    end
  end
end
