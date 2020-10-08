require 'test_helper'
require_relative '../support/normalizer_test_helper'

class SmbcNormalizerTest < Minitest::Test
  include NormalizerTestHelper

  def subject
    SmbcNormalizer
  end

  def setup
    stub_request(:get, 'https://www.smbc-comics.com/comic/back')
      .to_return(body: sample_post)

    stub_request(:get, 'https://www.smbc-comics.com/comic/kill')
      .to_return(body: sample_post)
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

  def test_normalization
    assert(normalized.any?)
  end

  def test_hidden_image
    result = normalized.first
    assert_equal(2, result[:attachments].count)
  end
end
