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
    NormalizedEntity.new(
      feed_id: feed.id,
      uid: 'http://kimchicuddles.com/post/178513799060',
      link: 'http://kimchicuddles.com/post/178513799060',
      published_at: DateTime.parse('2018-09-27 15:53:34 UTC'),
      text: 'http://kimchicuddles.com/post/178513799060',
      attachments: [ATTACHMENT_URL],
      comments: ["Who are some people you’re grateful for right now?\nIf you appreciate my work, check out my Patreon: https://www.patreon.com/kimchicuddles"],
      validation_errors: []
    )
  end

  def test_normalized_sample
    assert_equal(expected, normalized.first)
  end
end
