require "rails_helper"
require "support/shared_examples_a_normalizer"

RSpec.describe RedakciyaNormalizer do
  it_behaves_like "a normalizer" do
    let(:feed) do
      create(
        :feed,
        name: "redakciya",
        url: "https://www.youtube.com/feeds/videos.xml?channel_id=UC1eFXmJNkjITxPFWTy6RsWg",
        loader: "http",
        processor: "youtube",
        normalizer: "redakciya"
      )
    end
  end
end
