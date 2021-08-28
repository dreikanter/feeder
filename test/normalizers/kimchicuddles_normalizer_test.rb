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
    entity = JSON.parse(file_fixture('feeds/kimchicuddles/entity.json').read)
    value = entity['published_at']
    entity['published_at'] = DateTime.parse(value) if value

    NormalizedEntity.new(
      entity.symbolize_keys.merge(
        feed_id: feed.id,
        attachments: [ATTACHMENT_URL]
      )
    )
  end

  def test_normalized_sample
    assert_equal(expected, normalized.first)
  end
end
