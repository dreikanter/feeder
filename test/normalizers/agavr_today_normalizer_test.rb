require 'test_helper'

class AgavrTodayNormalizerTest < Minitest::Test
  include NormalizerTestHelper

  def subject
    AgavrTodayNormalizer
  end

  def processor
    RssProcessor
  end

  def sample_data_file
    'feed_agavr_today.xml'
  end

  def expected
    NormalizedEntity.new(
      feed_id: feed.id,
      uid: 'http://tele.ga/agavr_today/126.html',
      attachments: [],
      comments: [],
      link: 'http://tele.ga/agavr_today/126.html',
      published_at: DateTime.parse('2017-09-07 14:51:45 +0000'),
      text: 'Находясь в настоящий момент... - http://tele.ga/agavr_today/126.html',
      validation_errors: []
    )
  end

  def test_normalization
    assert_equal(expected, normalized.first)
  end
end
