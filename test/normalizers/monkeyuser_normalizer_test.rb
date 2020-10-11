require 'test_helper'

class MonkeyuserNormalizerTest < Minitest::Test
  include NormalizerTestHelper

  def subject
    MonkeyuserNormalizer
  end

  def processor
    FeedjiraProcessor
  end

  def sample_data_file
    'feed_monkeyuser.xml'
  end

  def test_normalization
    assert(normalized.any?)
  end

  def expected
    NormalizedEntity.new(
      feed_id: feed.id,
      uid: 'https://www.monkeyuser.com/2019/platypuscorn/',
      link: 'https://www.monkeyuser.com/2019/platypuscorn/',
      published_at: DateTime.parse('2019-08-20 00:00:00 UTC'),
      text: 'Platypuscorn - https://www.monkeyuser.com/2019/platypuscorn/ - https://www.monkeyuser.com/2019/platypuscorn/',
      attachments: ['https://www.monkeyuser.com/assets/images/2019/145-platypuscorn.png'],
      comments: [],
      validation_errors: []
    )
  end

  def test_normalized_sample
    assert_equal(expected, normalized.first)
  end
end
