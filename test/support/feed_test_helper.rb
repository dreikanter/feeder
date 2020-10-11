module FeedTestHelper
  def subject
    Pull.call(feed)
  end

  def feed
    @feed ||= build(:feed, feed_config)
  end

  def feed_config
    raise 'not implemented'
  end

  def fixture_path
    raise 'not implemented'
  end

  def expected_entity
    content = file_fixture(fixture_path).read
    result = JSON.parse(content).symbolize_keys
    published_at = DateTime.parse(result.fetch(:published_at))
    NormalizedEntity.new(result.merge(published_at: published_at, feed_id: feed.id))
  end

  def test_entity_normalization
    assert_equal(expected_entity, subject.first)
  end
end
