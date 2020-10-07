require 'test_helper'

class LunarbaboonTest < Minitest::Test
  def subject
    Pull.call(feed)
  end

  def feed
    build(:feed, **feed_config)
  end

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

  def expected_entity
    content = file_fixture('entities/lunarbaboon.json').read
    result = JSON.parse(content).symbolize_keys
    return result unless result.key?(:published_at)
    result[:published_at] = DateTime.parse(result[:published_at])
    result
  end

  def test_entity_normalization
    assert_equal(expected_entity, subject.first)
  end
end
