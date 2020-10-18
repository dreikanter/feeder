require 'test_helper'

class KimchicuddlesNormalizerTest < Minitest::Test
  include NormalizerTestHelper

  def subject
    KimchicuddlesNormalizer
  end

  def processor
    FeedjiraProcessor
  end

  def sample_data_file
    'feed_kimchicuddles.xml'
  end

  ATTACHMENT_URL = 'https://example.com'.freeze

  def options
    { image_fetcher: ->(_) { ATTACHMENT_URL } }
  end

  def expected
    normalized_entity_fixture(
      'kimchicuddles.json',
      feed_id: feed.id,
      attachments: [ATTACHMENT_URL]
    )
  end

  def test_normalized_sample
    assert_equal(expected, normalized.first)
  end
end
