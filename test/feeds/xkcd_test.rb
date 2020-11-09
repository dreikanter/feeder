require 'test_helper'

class XkcdTest < Minitest::Test
  include FeedTestHelper

  def feed_config
    {
      name: 'xkcd',
      processor: 'rss',
      normalizer: 'xkcd',
      url: 'https://xkcd.com/rss.xml'
    }
  end

  def expected_fixture_path
    'entities/xkcd.json'
  end

  def setup
    stub_request(:get, 'https://xkcd.com/rss.xml')
      .to_return(
        body: file_fixture('feeds/xkcd.xml').read,
        headers: { 'Content-Type' => 'text/xml' }
      )
  end
end
