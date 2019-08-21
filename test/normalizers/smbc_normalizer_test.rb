require 'test_helper'
require_relative '../support/normalizer_test_helper'

class SmbcNormalizerTest < Minitest::Test
  include NormalizerTestHelper

  def subject
    SmbcNormalizer
  end

  def processor
    RssProcessor
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
    assert(normalized.any?)
    assert(normalized.each(&:success?))
  end

  def test_hidden_image
    result = normalized.first.value!
    assert_equal(2, result[:attachments].count)
  end
end
