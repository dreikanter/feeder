require 'test_helper'
require_relative '../support/normalizer_test_helper'

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
    assert(normalized.each(&:success?))
  end

  # rubocop:disable Metric/LineLength
  FIRST_SAMPLE = {
    uid: 'https://www.monkeyuser.com/2019/platypuscorn/',
    link: 'https://www.monkeyuser.com/2019/platypuscorn/',
    published_at: DateTime.parse('2019-08-20 00:00:00 UTC'),
    text: 'Platypuscorn - https://www.monkeyuser.com/2019/platypuscorn/ - https://www.monkeyuser.com/2019/platypuscorn/',
    attachments: ['https://www.monkeyuser.com/assets/images/2019/145-platypuscorn.png'],
    comments: []
  }.freeze
  # rubocop:enable Metric/LineLength

  def test_normalized_sample
    assert_equal(FIRST_SAMPLE, normalized.first.value!)
  end
end
