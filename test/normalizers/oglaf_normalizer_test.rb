require 'test_helper'

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

  def expected
    NormalizedEntity.new(
      feed_id: feed.id,
      uid: 'https://www.oglaf.com/thesitter/',
      link: 'https://www.oglaf.com/thesitter/',
      published_at: DateTime.parse('2019-08-18 00:00:00 +0000'),
      text: 'Legend of the Sitter - https://www.oglaf.com/thesitter/',
      attachments: ['https://media.oglaf.com/comic/thesitter.jpg'],
      comments: ['formerly the baby sitter'],
      validation_errors: []
    )
  end

  def test_first_entity
    assert_equal(expected, normalized.first)
  end
end
