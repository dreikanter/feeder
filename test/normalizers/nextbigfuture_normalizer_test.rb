require 'test_helper'
require_relative '../support/normalizer_test_helper'

class NextbigfutureNormalizerTest < Minitest::Test
  include NormalizerTestHelper

  def sample_data_file
    'feed_nextbigfuture.xml'
  end

  def processor
    WordpressProcessor
  end

  def subject
    NextbigfutureNormalizer
  end

  ATTACHMENT_URL = 'https://example.com'.freeze

  def options
    { thumb_fetcher: ->(_) { ATTACHMENT_URL } }
  end

  def test_have_sample_data
    assert(processed.present?)
    assert(processed.length.positive?)
  end

  def test_normalization
    assert(normalized.any?)
    assert(normalized.each(&:success?))
  end

  # rubocop:disable Metric/LineLength
  FIRST_SAMPLE = {
    link: 'https://www.nextbigfuture.com/2018/11/rise-of-china-and-strictly-business-competition-in-the-world.html',
    published_at: Time.parse('2018-11-27 09:19:49 UTC'),
    text: 'Rise of China and Strictly Business Competition in the World - https://www.nextbigfuture.com/2018/11/rise-of-china-and-strictly-business-competition-in-the-world.html',
    comments: ['There have been many books written about\\n\\nthe rise of China'],
    attachments: [ATTACHMENT_URL],
    validation_errors: []
  }.freeze
  # rubocop:enable Metric/LineLength

  def test_normalized_sample
    result = normalized.first.value!
    FIRST_SAMPLE.keys.each do |key|
      assert_equal(FIRST_SAMPLE[key], result[key])
    end
  end
end
