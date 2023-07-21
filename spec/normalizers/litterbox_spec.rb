require "rails_helper"
require "support/shared_examples_a_normalizer"

RSpec.describe LitterboxNormalizer do
  subject(:subject_name) { described_class }

  context "with normal content" do
    it_behaves_like "a normalizer" do
      let(:feed) do
        create(
          :feed,
          name: "litterbox",
          loader: "http",
          processor: "wordpress",
          normalizer: "litterbox",
          url: "https://www.litterboxcomics.com/feed/"
        )
      end

      let(:feed_fixture) { "feeds/litterbox/feed.xml" }
      let(:normalized_fixture) { "feeds/litterbox/normalized.json" }

      before do
        stub_request(:get, "https://www.litterboxcomics.com/claw-machine/")
          .to_return(body: file_fixture("feeds/litterbox/post.html").read)

        stub_request(:get, "https://www.litterboxcomics.com/claw-machine-bonus/")
          .to_return(body: file_fixture("feeds/litterbox/bonus_panel.html").read)
      end
    end
  end

  context "with slides" do
    it_behaves_like "a normalizer" do
      let(:feed) do
        create(
          :feed,
          name: "litterbox",
          loader: "http",
          processor: "wordpress",
          normalizer: "litterbox",
          url: "https://www.litterboxcomics.com/feed/"
        )
      end

      let(:feed_fixture) { "feeds/litterbox/slides/feed.xml" }
      let(:normalized_fixture) { "feeds/litterbox/slides/normalized.json" }

      before do
        stub_request(:get, "https://www.litterboxcomics.com/worlds-collide/")
          .to_return(body: file_fixture("feeds/litterbox/slides/post.html").read)

        stub_request(:get, "https://www.litterboxcomics.com/worlds-collide-bonus/")
          .to_return(body: file_fixture("feeds/litterbox/slides/bonus_panel.html").read)
      end
    end
  end
end
