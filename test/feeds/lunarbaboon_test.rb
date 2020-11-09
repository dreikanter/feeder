require 'test_helper'

class LunarbaboonTest < Minitest::Test
  include FeedTestHelper

  def feed_config
    {
      name: 'lunarbaboon',
      processor: 'feedjira',
      normalizer: 'lunarbaboon',
      url: 'http://www.lunarbaboon.com/comics/rss.xml'
    }
  end

  def setup
    stub_request(:get, 'http://www.lunarbaboon.com/comics/rss.xml')
      .to_return(
        body: file_fixture('feeds/lunarbaboon.xml'),
        headers: { 'Content-Type' => 'text/xml' }
      )
  end

  def expected_fixture_path
    'entities/lunarbaboon.json'
  end
end
