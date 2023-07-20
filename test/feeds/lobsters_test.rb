require "test_helper"

class LobstersTest < Minitest::Test
  include FeedTestHelper

  def feed_config
    {
      name: "lobsters-ruby",
      loader: "http",
      processor: "lobsters",
      normalizer: "lobsters",
      url: "https://lobste.rs/t/ruby.rss"
    }
  end

  def source_fixture_path
    "feeds/lobsters/feed.xml"
  end

  def expected_fixture_path
    "feeds/lobsters/entity.json"
  end
end
