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

  def test_normalization
    assert(normalized.any?)
    assert(normalized.each(&:success?))
  end

  FIRST_SAMPLE = {
    uid: 'https://www.oglaf.com/thesitter/',
    link: 'https://www.oglaf.com/thesitter/',
    published_at: DateTime.parse('2019-08-18 00:00:00 +0000'),
    text: 'Legend of the Sitter - https://www.oglaf.com/thesitter/',
    attachments: ['https://media.oglaf.com/comic/thesitter.jpg'],
    comments: ['formerly the baby sitter'],
    validation_errors: []
  }.freeze

  def test_normalized_sample
    assert_equal(FIRST_SAMPLE, normalized.first.value!)
  end
end
