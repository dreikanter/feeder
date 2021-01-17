module FeedTestHelper
  def subject
    Pull.call(feed).first
  end

  def setup
    super
    stub_feed_url if feed_url.present?
  end

  def stub_feed_url
    stub_request(:get, feed_url)
      .to_return(
        body: file_fixture(source_fixture_path).read,
        headers: { 'Content-Type' => 'text/xml' }
      )
  end

  def feed_url
    feed_config[:url]
  end

  def feed
    @feed ||= create(:feed, feed_config)
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

  # :reek:FeatureEnvy
  def normalize(item)
    replacements = {
      'published_at' => DateTime.parse(item.fetch('published_at')),
      'feed_id' => feed.id
    }

    NormalizedEntity.new(item.merge(replacements).symbolize_keys)
  end

  def test_entity_normalization
    # puts JSON.pretty_generate subject.as_json
    assert_equal(expected, subject, error_message)
  end

  def error_message
    expected_json = JSON.pretty_generate(expected.as_json)
    actual_json = JSON.pretty_generate(subject.as_json)
    "Expected:\n\n#{expected_json}\n\nActual:\n\n#{actual_json}\n"
  end
end
