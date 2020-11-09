module FeedTestHelper
  def subject
    Pull.call(feed).first
  end

  def setup
    stub_request(:get, feed_config.fetch(:url))
      .to_return(
        body: file_fixture(source_fixture_path).read,
        headers: { 'Content-Type' => 'text/xml' }
      )
  end

  def feed_defaults
    {
      id: 1
    }
  end

  def feed
    @feed ||= build(:feed, feed_defaults.merge(feed_config))
  end

  def feed_config
    raise 'not implemented'
  end

  def source_fixture_path
    raise 'not implemented'
  end

  def expected_fixture_path
    raise 'not implemented'
  end

  def expected
    data = JSON.parse(file_fixture(expected_fixture_path).read)
    return normalize(data) if data.is_a?(Hash)
    data.map { |item| normalize(item) }
  end

  def normalize(item)
    replacements = {
      'published_at' => DateTime.parse(item.fetch('published_at')),
      'feed_id' => feed.id
    }

    NormalizedEntity.new(item.merge(replacements).symbolize_keys)
  end

  def test_entity_normalization
    # puts JSON.pretty_generate(expected.map(&:as_json))
    # puts JSON.pretty_generate(subject.map(&:as_json))
    assert_equal(expected, subject)
  end
end
