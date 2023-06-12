require "test_helper"

class NitterNormalizerTest < Minitest::Test
  extend Minitest::Spec::DSL

  let(:subject) { NitterNormalizer }

  let(:feed) do
    build(
      :feed,
      loader: "nitter",
      processor: "feedjira",
      normalizer: "nitter",
      options: {
        "twitter_user" => "username",
        "only_with_attachments" => true,
        "ignore_retweets" => true
      }
    )
  end

  let(:entities) { FeedjiraProcessor.call(content, feed: feed, import_limit: 0) }
  let(:content) { File.read(file_fixture("feeds/nitter/rss.xml")) }

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

  def test_process_tweet_with_image
    freeze_time do
      normalized_entity = subject.call(tweet_with_image)
      assert_equal expected, normalized_entity.as_json
    end
  end

  def test_process_tweet_with_no_image
    normalized_entity = subject.call(tweet_with_no_image)
    assert_includes normalized_entity.validation_errors, "no images"
  end

  def test_process_retweet
    normalized_entity = subject.call(tweet_retweet)
    assert_includes normalized_entity.validation_errors, "retweet"
  end
end
