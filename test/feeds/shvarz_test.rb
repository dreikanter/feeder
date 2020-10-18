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

  def setup
    stub_request(:get, 'https://shvarz.livejournal.com/data/rss')
      .to_return(
        body: file_fixture('feeds/shvarz.xml'),
        headers: { 'Content-Type' => 'text/xml' }
      )
  end

  def fixture_path
    'entities/shvarz.json'
  end
end
