require 'test_helper'

class BazarNormalizerTest < Minitest::Test
  include NormalizerTestHelper

  def subject
    BazarNormalizer
  end

  def processor
    FeedjiraProcessor
  end

  def sample_data_file
    'feed_bazar.xml'
  end

  def expected
    normalized_entity_fixture('bazar.json', feed_id: feed.id)
  end

  def test_normalized_sample
    assert_equal(expected, normalized.first)
  end
end
