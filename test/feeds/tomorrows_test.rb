require 'test_helper'

class TomorrowsTest < Minitest::Test
  def subject
    Pull.call(feed)
  end

  def feed
    build(:feed, **feed_config)
  end

  def feed_config
    {
      name: '365tomorrows',
      processor: 'rss',
      normalizer: 'tomorrows',
      url: 'http://365tomorrows.com/feed/'
    }
  end

  def setup
    stub_request(:get, 'http://365tomorrows.com/feed/')
      .to_return(
        body: file_fixture('feeds/tomorrows.xml'),
        headers: { 'Content-Type' => 'text/xml' }
      )

    stub_request(:get, %r{https://365tomorrows.com/\d+/.*})
      .to_return(
        body: file_fixture('feeds/tomorrows_post.html'),
        headers: { 'Content-Type' => 'text/html' }
      )
  end

  def expected_entity
    content = file_fixture('entities/tomorrows.json').read
    result = JSON.parse(content).symbolize_keys
    return result unless result.key?(:published_at)
    result[:published_at] = DateTime.parse(result[:published_at])
    result
  end

  def test_entity_normalization
    assert_equal(expected_entity, subject.first)
  end
end
