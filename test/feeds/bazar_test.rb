require "test_helper"

class BazarTest < Minitest::Test
  include FeedTestHelper

  def feed_config
    {
      name: "bazar",
      processor: "feedjira",
      normalizer: "bazar",
      url: "https://meduza.io/rss/podcasts/knizhnyy-bazar"
    }
  end

  def source_fixture_path
    "feeds/bazar/feed.xml"
  end

  def expected_fixture_path
    "feeds/bazar/entity.json"
  end
end
