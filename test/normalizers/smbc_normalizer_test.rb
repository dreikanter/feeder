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
    {
      content: 'SAMPLE CONTENT'
    }
  end

  def test_normalization
    normalized.each do |result|
      assert(result.success?)
    end
  end

  def test_hidden_image
    # fetch_sample_post
  end
end
