require 'test_helper'

class NormalizedEntityTest < Minitest::Test
  def subject
    NormalizedEntity
  end

  def feed
    create(:feed, after: import_threshold)
  end

  def import_threshold
    1.day.ago
  end

  def test_not_stale
    published_at = import_threshold + 1.second
    normalized_entry = NormalizedEntity.new(feed_id: feed.id, published_at: published_at)
    refute(normalized_entry.stale?)
  end

  def test_stale
    published_at = import_threshold
    normalized_entry = NormalizedEntity.new(feed_id: feed.id, published_at: published_at)
    assert(normalized_entry.stale?)
  end

  def test_not_stale_with_default_published_at
    normalized_entry = NormalizedEntity.new(feed_id: feed.id)
    refute(normalized_entry.stale?)
  end
end
