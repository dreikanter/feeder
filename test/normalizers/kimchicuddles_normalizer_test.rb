require 'test_helper'
require_relative '../support/normalizer_test_helper'

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

  def test_have_sample_data
    assert(processed.present?)
    assert(processed.length.positive?)
  end

  def test_normalization
    assert(normalized.any?)
  end

  # rubocop:disable Layout/LineLength
  FIRST_SAMPLE = {
    link: 'http://kimchicuddles.com/post/178513799060',
    published_at: Time.parse('2018-09-27 15:53:34 UTC'),
    text: 'http://kimchicuddles.com/post/178513799060',
    attachments: [ATTACHMENT_URL],
    comments: ["Who are some people you’re grateful for right now?\nIf you appreciate my work, check out my Patreon: https://www.patreon.com/kimchicuddles"],
    validation_errors: []
  }.freeze
  # rubocop:enable Layout/LineLength

  def test_normalized_sample
    result = normalized.first
    FIRST_SAMPLE.each_key do |key|
      assert_equal(FIRST_SAMPLE[key], result[key])
    end
  end
end
