require "test_helper"

class NitterProcessorTest < Minitest::Test
  extend Minitest::Spec::DSL

  let(:subject) { NitterProcessor }
  let(:content) { file_fixture("feeds/nitter/rss.xml").read }

  let(:feed) do
    build(
      :feed,
      loader: "nitter",
      processor: "nitter",
      normalizer: "nitter",
      options: {
        "twitter_user" => "username",
        "only_with_attachments" => true,
        "ignore_retweets" => true
      }
    )
  end

  let(:expected_uids) do
    [
      "https://twitter.com/extrafabulous/status/1664634629456887813#m",
      "https://twitter.com/extrafabulous/status/1664067666162728960#m",
      "https://twitter.com/PervisTime/status/1664280381473058817#m"
    ]
  end

  def test_uids_should_be_twitter_url
    entities = subject.call(content, feed: feed, import_limit: 0)
    assert_equal expected_uids, entities.map(&:uid)
  end
end
