require 'test_helper'

class NextbigfutureNormalizerTest < Minitest::Test
  include NormalizerTestHelper

  def sample_data_file
    'feed_nextbigfuture.xml'
  end

  def processor
    WordpressProcessor
  end

  def subject
    NextbigfutureNormalizer
  end

  ATTACHMENT_URL = 'https://example.com'.freeze

  def options
    { thumb_fetcher: ->(_) { ATTACHMENT_URL } }
  end

  def test_have_sample_data
    assert(processed.present?)
    assert(processed.length.positive?)
  end

  def test_normalization
    assert(normalized.any?)
  end

  def expected
    NormalizedEntity.new(
      feed_id: feed.id,
      uid: 'https://www.nextbigfuture.com/2018/11/rise-of-china-and-strictly-business-competition-in-the-world.html',
      link: 'https://www.nextbigfuture.com/2018/11/rise-of-china-and-strictly-business-competition-in-the-world.html',
      published_at: Time.parse('2018-11-27 09:19:49 UTC'),
      text: 'Rise of China and Strictly Business Competition in the World - https://www.nextbigfuture.com/2018/11/rise-of-china-and-strictly-business-competition-in-the-world.html',
      comments: ['There have been many books written about\\n\\nthe rise of China'],
      attachments: [ATTACHMENT_URL],
      validation_errors: []
    )
  end

  def test_normalized_sample
    assert_equal(expected, normalized.first)
  end
end
