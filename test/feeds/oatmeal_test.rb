require 'test_helper'

class OatmealTest < Minitest::Test
  include FeedTestHelper

  def feed_config
    {
      name: 'oatmeal',
      processor: 'rss',
      normalizer: 'oatmeal',
      url: 'https://feeds.feedburner.com/oatmealfeed'
    }
  end

  def source_fixture_path
    'feeds/oatmeal/feed.xml'
  end

  def expected_fixture_path
    'feeds/oatmeal/entity.json'
  end
end
