require "rails_helper"
require "support/shared_examples_a_normalizer"

RSpec.describe WumoNormalizer do
  it_behaves_like "a normalizer" do
    let(:feed) do
      create(
        :feed,
        name: "wumo",
        url: "https://wumo.com/wumo?view=rss",
        loader: "http",
        processor: "rss",
        normalizer: "wumo"
      )
    end
  end
end
