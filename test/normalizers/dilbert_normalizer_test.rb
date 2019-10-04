require 'test_helper'
require_relative '../support/normalizer_test_helper'

class DilbertNormalizerTest < Minitest::Test
  include NormalizerTestHelper

  def subject
    DilbertNormalizer
  end

  def processor
    RssProcessor
  end

  def sample_data_file
    'feed_dilbert.xml'.freeze
  end

  def test_have_sample_data
    assert(processed.present?)
    assert(processed.length.positive?)
  end

  def test_normalization
    assert(normalized.any?)
    assert(normalized.all?(&:success?))
  end

  # rubocop:disable Metrics/LineLength
  def test_text
    result = normalized.first.value![:text]
    assert_equal('Garbage Man Breaks Fourth Wall - Comic for October 04, 2019', result)
  end
  # rubocop:enable Metrics/LineLength
end
