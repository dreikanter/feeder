require "rails_helper"

RSpec.describe NitterNormalizer do
  subject(:normalizer) { described_class }

  let(:feed) do
    build(
      :feed,
      loader: "nitter",
      processor: "feedjira",
      normalizer: "nitter",
      import_limit: 0,
      options: {
        "twitter_user" => "username",
        "only_with_attachments" => true,
        "ignore_retweets" => true
      }
    )
  end

  let(:entities) { FeedjiraProcessor.call(content: content, feed: feed) }
  let(:content) { file_fixture("feeds/nitter/rss.xml").read }

  let(:tweet_with_image) { entities[0] }
  let(:tweet_with_no_image) { entities[1] }
  let(:tweet_retweet) { entities[2] }

  let(:expected) do
    {
      "feed_id" => nil,
      "uid" => "https://nitter.net/extrafabulous/status/1664634629456887813#m",
      "link" => "https://twitter.com/extrafabulous/status/1664634629456887813#m",
      "published_at" => Time.parse("2023-06-02 14:06:37 UTC"),
      "text" => "Image - !https://twitter.com/extrafabulous/status/1664634629456887813#m",
      "attachments" => ["https://nitter.net/pic/media%2FFxn4X5JWYAcPDCS.jpg"],
      "comments" => [],
      "validation_errors" => []
    }
  end

  before { freeze_time }

  it "processes tweet with an image" do
    expect(normalizer.call(tweet_with_image).as_json).to eq(expected)
  end

  it "processes tweet with no image" do
    expect(normalizer.call(tweet_with_no_image).validation_errors).to include("no images")
  end

  it "processes retweet" do
    expect(normalizer.call(tweet_retweet).validation_errors).to include("retweet")
  end
end
