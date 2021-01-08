require 'test_helper'

class ReworkTest < Minitest::Test
  include FeedTestHelper

  def feed_config
    {
      name: 'rework',
      processor: 'feedjira',
      normalizer: 'rework',
      url: 'https://feeds.transistor.fm/rework'
    }
  end

  def source_fixture_path
    'feeds/rework.xml'
  end

  def expected_fixture_path
    'entities/rework.json'
  end
end
