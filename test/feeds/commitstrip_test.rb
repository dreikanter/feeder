require 'test_helper'

class CommitstripTest < Minitest::Test
  include FeedTestHelper

  def feed_config
    {
      name: 'commitstrip',
      processor: 'feedjira',
      normalizer: 'commitstrip',
      url: 'https://www.commitstrip.com/en/feed/'
    }
  end

  def source_fixture_path
    'feeds/commitstrip.xml'
  end

  def expected_fixture_path
    'entities/commitstrip.json'
  end
end
