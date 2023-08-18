require "rails_helper"
require "support/shared_examples_a_normalizer"

RSpec.describe YoutubeNormalizer do
  it_behaves_like "a normalizer" do
    let(:feed) do
      create(
        :feed,
        name: "youtube",
        url: "https://www.youtube.com/feeds/videos.xml?channel_id=1",
        loader: "http",
        processor: "youtube",
        normalizer: "youtube"
      )
    end
  end
end
