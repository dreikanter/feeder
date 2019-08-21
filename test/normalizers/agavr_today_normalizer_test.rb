require 'test_helper'
require_relative '../support/normalizer_test_helper'

class AgavrTodayNormalizerTest < Minitest::Test
  include NormalizerTestHelper

  def subject
    AgavrTodayNormalizer
  end

  def processor
    RssProcessor
  end

  def sample_data_file
    'feed_agavr_today.xml'
  end

  def test_have_sample_data
    assert(processed.present?)
    assert(processed.length.positive?)
  end

  def test_normalization
    assert(normalized.any?)
    assert(normalized.each(&:success?))
  end
end
