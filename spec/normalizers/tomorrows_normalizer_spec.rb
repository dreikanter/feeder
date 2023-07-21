require "rails_helper"
require "support/shared_examples_a_normalizer"

RSpec.describe TomorrowsNormalizer do
  subject(:subject_name) { described_class }

  it_behaves_like "a normalizer" do
    let(:feed) do
      create(
        :feed,
        name: "365tomorrows",
        loader: "http",
        processor: "rss",
        normalizer: "tomorrows",
        url: "http://365tomorrows.com/feed/"
      )
    end

    before do
      stub_request(:get, %r{https://365tomorrows.com/\d+/.*})
        .to_return(body: file_fixture("feeds/365tomorrows/post.html"))
    end
  end
end
