require 'test_helper'

class TomorrowsTest < Minitest::Test
  include FeedTestHelper

  def feed_config
    {
      name: '365tomorrows',
      processor: 'rss',
      normalizer: 'tomorrows',
      url: 'http://365tomorrows.com/feed/'
    }
  end

  def setup
    super

    stub_request(:get, %r{https://365tomorrows.com/\d+/.*})
      .to_return(
        body: file_fixture('feeds/tomorrows_post.html'),
        headers: { 'Content-Type' => 'text/html' }
      )
  end

  def source_fixture_path
    'feeds/tomorrows.xml'
  end

  def expected_fixture_path
    'entities/tomorrows.json'
  end
end
