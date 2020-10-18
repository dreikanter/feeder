require 'test_helper'

class SchneierNormalizerTest < Minitest::Test
  include NormalizerTestHelper

  def subject
    SchneierNormalizer
  end

  def processor
    AtomProcessor
  end

  def sample_data_file
    'feed_schneier.xml'
  end

  def expected
    normalized_entity_fixture('schneier.json', feed_id: feed.id)
  end

  def test_normalized_sample
    assert_equal(expected, normalized.first)
  end
end
