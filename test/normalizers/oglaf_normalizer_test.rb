require 'test_helper'
require_relative '../support/normalizer_test_helper'

class OglafNormalizerTest < Minitest::Test
  include NormalizerTestHelper

  def subject
    OglafNormalizer
  end

  def processor
    RssProcessor
  end

  def sample_data_file
    'feed_oglaf.xml'
  end

  def setup
    super
    sample_post = sample_file('post_oglaf.html')
    stub_request(:get, /www.oglaf.com/).to_return(body: sample_post)
  end

  def test_normalization
    assert(normalized.any?)
    assert(normalized.all?(&:success?))
  end

  def test_uid
    assert_equal(
      'https://www.oglaf.com/thesitter/',
      normalized.first.value![:uid]
    )
  end

  def test_link
    assert_equal(
      'https://www.oglaf.com/thesitter/',
      normalized.first.value![:link]
    )
  end

  def test_published_at
    assert_equal(
      DateTime.parse('2019-08-18 00:00:00 +0000'),
      normalized.first.value![:published_at]
    )
  end

  EXPECTED_TEXT = 'Legend of the Sitter - https://www.oglaf.com/thesitter/'.freeze

  def test_text
    assert_equal(EXPECTED_TEXT, normalized.first.value![:text])
  end

  EXPECTED_ATTACHMENTS = [
    'https://media.oglaf.com/comic/thesitter.jpg'
  ].freeze

  def test_attachments
    assert_equal(EXPECTED_ATTACHMENTS, normalized.first.value![:attachments])
  end

  EXPECTED_COMMENTS = [
    'formerly the baby sitter'
  ].freeze

  def test_comments
    assert_equal(EXPECTED_COMMENTS, normalized.first.value![:comments])
  end

  def test_validation_errors
    assert_empty(normalized.first.value![:validation_errors])
  end
end
