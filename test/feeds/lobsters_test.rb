require 'test_helper'

class LobstersTest < Minitest::Test
  include FeedTestHelper

  def feed_config
    {
      name: 'lobsters-ruby',
      processor: 'feedjira',
      normalizer: 'lobsters',
      url: 'https://lobste.rs/t/ruby.rss'
    }
  end

  def source_fixture_path
    'feeds/lobsters.xml'
  end

  def expected_fixture_path
    'entities/lobsters.json'
  end
end
