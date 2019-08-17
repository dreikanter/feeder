require 'test_helper'
require_relative '../support/normalizer_test_helper'

class PoorlydrawnlinesNormalizerTest < Minitest::Test
  include NormalizerTestHelper
  def subject
    Normalizers::PoorlydrawnlinesNormalizer
  end

  def processor
    Processors::FeedjiraProcessor
  end

  def sample_data_file
    'feed_poorlydrawnlines.xml'
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
    'uid' => 'http://www.poorlydrawnlines.com/comic/hello/',
    'link' => 'http://www.poorlydrawnlines.com/comic/hello/',
    'published_at' => Time.parse('2018-10-22 16:03:51 UTC'),
    'text' => 'Hello - http://www.poorlydrawnlines.com/comic/hello/',
    'attachments' => ['http://www.poorlydrawnlines.com/wp-content/uploads/2018/10/hello.png'],
    'comments' => []
  }.freeze

  def test_normalized_sample
    assert_equal(FIRST_SAMPLE, normalized.first.value!)
  end
end
