require "test_helper"

class ZippyTest < Minitest::Test
  include FeedTestHelper

  def feed_config
    {
      name: "zippy",
      loader: "http",
      processor: "feedjira",
      normalizer: "zippy",
      url: "https://www.comicsrss.com/rss/zippy-the-pinhead.rss"
    }
  end

  def source_fixture_path
    "feeds/zippy/feed.xml"
  end

  def expected_fixture_path
    "feeds/zippy/entity.json"
  end
end
