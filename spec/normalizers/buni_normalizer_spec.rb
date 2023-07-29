require "rails_helper"
require "support/shared_examples_a_normalizer"

RSpec.describe BuniNormalizer do
  subject(:subject_name) { described_class }

  it_behaves_like "a normalizer" do
    let(:feed) do
      create(
        :feed,
        name: "buni",
        loader: "http",
        processor: "feedjira",
        normalizer: "buni",
        url: "http://bunicomic.com/feed/"
      )
    end

    before do
      webtoons_post = file_fixture("feeds/buni/post_webtoons.html").read
      stub_request(:get, "http://www.bunicomic.com/2019/11/23/too-early/")
        .to_return(status: 200, body: webtoons_post)

      sample_post = file_fixture("feeds/buni/post.html").read
      stub_request(:get, %r{^http://www.bunicomic.com})
        .to_return(status: 200, body: sample_post)
    end
  end
end
