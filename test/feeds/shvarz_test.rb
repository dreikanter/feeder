require 'test_helper'

class ShvarzTest < Minitest::Test
  include FeedTestHelper

  def feed_config
    {
      name: 'shvarz',
      processor: 'rss',
      normalizer: 'livejournal',
      url: 'https://shvarz.livejournal.com/data/rss'
    }
  end

  def source_fixture_path
    'feeds/shvarz.xml'
  end

  def expected_fixture_path
    'entities/shvarz.json'
  end
end
