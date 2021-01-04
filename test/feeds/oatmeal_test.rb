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

  def setup
    stub_request(:get, 'https://feeds.feedburner.com/oatmealfeed')
      .to_return(
        headers: { 'Content-Type' => 'text/xml' },
        body: file_fixture('feeds/oatmeal.xml')
      )
  end

  def expected_fixture_path
    'entities/oatmeal.json'
  end
end
