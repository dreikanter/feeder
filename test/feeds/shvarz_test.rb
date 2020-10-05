require 'test_helper'

class ShvarzTest < Minitest::Test
  def subject
    Pull.call(feed)
  end

  def feed
    build(:feed, **feed_config)
  end

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

  def expected_entity
    content = file_fixture('entities/shvarz.json').read
    result = JSON.parse(content).symbolize_keys
    return result unless result.key?(:published_at)
    result[:published_at] = DateTime.parse(result[:published_at])
    result
  end

  def test_entity_normalization
    assert_equal(expected_entity, subject.first)
  end
end
