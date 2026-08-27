require "rails_helper"
require "support/shared_examples_a_normalizer"

RSpec.describe XkcdNormalizer do
  subject(:subject_name) { described_class }

  it_behaves_like "a normalizer" do
    let(:feed) do
      create(
        :feed,
        name: "xkcd",
        loader: "http",
        processor: "rss",
        normalizer: "xkcd",
        url: "https://xkcd.com/rss.xml"
      )
    end

    let(:feed_fixture) { "feeds/xkcd/feed.xml" }
    let(:normalized_fixture) { "feeds/xkcd/normalized.json" }

    before do
      stub_request(:get, %r{//xkcd.com/\d+})
        .to_return(body: file_fixture("feeds/xkcd/post.html").read)
    end
  end

  describe "fallback to the feed entry image" do
    subject(:normalized_entity) { described_class.call(entity) }

    let(:feed) do
      build(
        :feed,
        name: "xkcd",
        loader: "http",
        processor: "rss",
        normalizer: "xkcd",
        url: "https://xkcd.com/rss.xml"
      )
    end

    let(:entity) do
      RssProcessor.new(content: file_fixture("feeds/xkcd/feed.xml").read, feed: feed).process.first
    end

    before do
      stub_request(:get, %r{//xkcd.com/\d+})
        .to_return(body: file_fixture("feeds/xkcd/post_without_og_image.html").read)
    end

    it "uses the image from the feed entry description" do
      expect(normalized_entity.attachments).to eq(
        ["http://imgs.xkcd.com/comics/earth_temperature_timeline.png"]
      )
    end

    it "keeps the image title as a comment" do
      expect(normalized_entity.comments).to eq(
        ["[After setting your car on fire] Listen, your car's temperature has changed before."]
      )
    end
  end
end
