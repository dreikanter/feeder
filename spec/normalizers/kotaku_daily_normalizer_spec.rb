require "rails_helper"
require "support/shared_examples_a_normalizer"

RSpec.describe KotakuDailyNormalizer do
  subject(:subject_name) { described_class }

  before do
    stub_request(:get, %r{^https://kotaku.com/.*-\d+$})
      .to_return(body: file_fixture("feeds/kotaku_daily/post.html").read)
  end

  it_behaves_like "a normalizer" do
    let(:feed) do
      create(
        :feed,
        name: "kotaku_daily",
        url: "https://kotaku.com/rss",
        loader: "http",
        processor: "kotaku_daily",
        normalizer: "kotaku_daily",
        options: {"max_posts_number" => 5}
      )
    end
  end
end
