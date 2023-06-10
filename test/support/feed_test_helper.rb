module FeedTestHelper
  def subject
    Pull.call(feed).first
  end

  def setup
    super

    # TODO: Fix transactional tests
    Feed.delete_all

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
    @feed ||= create(:feed, **feed_config)
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
    return normalize(**data) if data.is_a?(Hash)
    data.map { normalize(**_1) }
  end

  # :reek:FeatureEnvy
  def normalize(hash)
    replacements = {
      'published_at' => DateTime.parse(hash.fetch('published_at')),
      'feed_id' => feed.id
    }

    NormalizedEntity.new(**hash.merge(replacements).symbolize_keys)
  end

  def test_entity_normalization
    assert_equal(expected, subject, error_message)
  end

  def error_message
    JSON.pretty_generate(expectation_diff)
  end

  def expectation_diff
    return subject.diff(expected).as_json unless subject.is_a?(Array)
    subject.zip(expected).map { |actual, expected| actual.diff(expected).as_json }
  end
end
