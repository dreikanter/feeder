require 'test_helper'

class MaremirTest < Minitest::Test
  include FeedTestHelper

  def feed_config
    {
      name: 'maremir',
      processor: 'rss',
      normalizer: 'maremir',
      url: 'http://maremir.org/feed/'
    }
  end

  def setup
    stub_request(:get, 'http://maremir.org/feed/')
      .to_return(
        headers: { 'Content-Type' => 'text/xml' },
        body: file_fixture('feeds/maremir.xml')
      )
  end

  def expected_fixture_path
    'entities/maremir.json'
  end
end
