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

  def setup
    stub_request(:get, 'https://www.commitstrip.com/en/feed/')
      .to_return(
        body: file_fixture('feeds/commitstrip.xml'),
        headers: { 'Content-Type' => 'text/xml' }
      )
  end

  def fixture_path
    'entities/commitstrip.json'
  end
end
