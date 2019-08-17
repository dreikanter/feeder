require 'test_helper'
require_relative '../support/normalizer_test_helper'

class SmbcNormalizerTest < Minitest::Test
  include NormalizerTestHelper

  def subject
    Normalizers::SmbcNormalizer
  end

  def processor
    Processors::RssProcessor
  end

  def sample_data_file
    'feed_smbc.xml'
  end

  def sample_post_file
    'post_smbc.html'
  end

  def options
    { content: sample_post }
  end

  def test_normalization
    result = normalized.first
    assert(result.success?)
  end

  def test_hidden_image
    result = normalized.first.value!
    assert_equal(2, result['attachments'].count)
  end
end
