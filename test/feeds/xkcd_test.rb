require 'test_helper'

class XkcdTest < Minitest::Test
  include FeedTestHelper

  def feed_config
    {
      name: 'xkcd',
      processor: 'rss',
      normalizer: 'xkcd',
      url: 'https://xkcd.com/rss.xml'
    }
  end

  def source_fixture_path
    'feeds/xkcd/feed.xml'
  end

  def expected_fixture_path
    'feeds/xkcd/entity.json'
  end
end
