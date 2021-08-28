require 'test_helper'

class RedakciyaNormalizerTest < Minitest::Test
  include NormalizerTestHelper

  def subject
    RedakciyaNormalizer
  end

  def processor
    YoutubeProcessor
  end

  def sample_data_file
    'feed_redakciya.xml'
  end

  def expected
    entity = JSON.parse(file_fixture('feeds/redakciya/entity.json').read)
    value = entity['published_at']
    entity['published_at'] = DateTime.parse(value) if value
    NormalizedEntity.new(entity.symbolize_keys.merge(feed_id: feed.id))
  end

  def test_normalized_sample
    assert_equal(expected, normalized.first)
  end
end
