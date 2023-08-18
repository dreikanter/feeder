require "rails_helper"
require "support/shared_examples_a_normalizer"

RSpec.describe MonkeyuserNormalizer do
  it_behaves_like "a normalizer" do
    let(:feed) do
      create(
        :feed,
        name: "monkeyuser",
        url: "https://www.monkeyuser.com/feed.xml",
        loader: "http",
        processor: "feedjira",
        normalizer: "monkeyuser"
      )
    end
  end
end
