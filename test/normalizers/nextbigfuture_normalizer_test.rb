require 'test_helper'
require_relative '../support/normalizer_test_helper'

class NextbigfutureNormalizerTest < Minitest::Test
  include NormalizerTestHelper

  def sample_data_file
    'feed_nextbigfuture.xml'
  end

  def processor
    Processors::WordpressProcessor
  end

  def subject
    Normalizers::NextbigfutureNormalizer
  end

  def test_have_sample_data
    assert(processed.present?)
    assert(processed.length.positive?)
  end

  def test_normalization
    assert(normalized.present?)
    assert_equal(processed.length, normalized.length)
  end

  FIRST_SAMPLE = {
    'link' => 'https://www.nextbigfuture.com/2018/11/rise-of-china-and-strictly-business-competition-in-the-world.html',
    'published_at' => Time.parse('2018-11-27 09:19:49 UTC'),
    'text' => 'Rise of China and Strictly Business Competition in the World - https://www.nextbigfuture.com/2018/11/rise-of-china-and-strictly-business-competition-in-the-world.html',
    'comments' => ['There have been many books written about\\n\\nthe rise of China']
  }.freeze

  # TODO: Test attachments

  def test_normalized_sample
    result = normalized.first.value!

    FIRST_SAMPLE.keys.each do |key|
      assert_equal(FIRST_SAMPLE[key], result[key])
    end
  end
end
