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
    normalized_entity_fixture('redakciya.json', feed_id: feed.id)
  end

  def test_normalized_sample
    assert_equal(expected, normalized.first)
  end
end
