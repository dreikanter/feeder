require 'test_helper'

class LunarbaboonTest < Minitest::Test
  include FeedTestHelper

  def feed_config
    {
      name: 'lunarbaboon',
      processor: 'feedjira',
      normalizer: 'lunarbaboon',
      url: 'http://www.lunarbaboon.com/comics/rss.xml'
    }
  end

  def source_fixture_path
    'feeds/lunarbaboon/feed.xml'
  end

  def expected_fixture_path
    'feeds/lunarbaboon/entity.json'
  end
end
