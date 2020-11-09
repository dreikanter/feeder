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

  def expected_fixture_path
    'entities/rework.json'
  end

  def setup
    stub_request(:get, 'https://feeds.transistor.fm/rework')
      .to_return(
        body: file_fixture('feeds/rework.xml'),
        headers: { 'Content-Type' => 'text/xml' }
      )
  end
end
