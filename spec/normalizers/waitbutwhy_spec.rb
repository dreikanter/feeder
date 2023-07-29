require "rails_helper"
require "support/shared_examples_a_normalizer"

RSpec.describe WaitbutwhyNormalizer do
  it_behaves_like "a normalizer" do
    let(:feed) do
      create(
        :feed,
        name: "waitbutwhy",
        url: "https://waitbutwhy.com/feed",
        loader: "http",
        processor: "feedjira",
        normalizer: "waitbutwhy"
      )
    end
  end
end
