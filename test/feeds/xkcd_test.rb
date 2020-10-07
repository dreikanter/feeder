require 'test_helper'

class XkcdTest < Minitest::Test
  def subject
    Pull.call(feed)
  end

  def feed
    build(:feed, **feed_config)
  end

  def feed_config
    {
      name: 'xkcd',
      processor: 'rss',
      normalizer: 'xkcd',
      url: 'https://xkcd.com/rss.xml'
    }
  end

  def setup
    stub_request(:get, 'https://xkcd.com/rss.xml')
      .to_return(
        body: file_fixture('feeds/xkcd.xml').read,
        headers: { 'Content-Type' => 'text/xml' }
      )
  end

  def expected_entity
    content = file_fixture('entities/xkcd.json').read
    result = JSON.parse(content).symbolize_keys
    result[:published_at] = DateTime.parse(result[:published_at])
    result
  end

  def test_entity_normalization
    assert_equal(expected_entity, subject.first)
  end
end
