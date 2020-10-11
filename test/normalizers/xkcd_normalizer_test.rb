require 'test_helper'

class XkcdNormalizerTest < Minitest::Test
  include NormalizerTestHelper

  def subject
    XkcdNormalizer
  end

  def processor
    RssProcessor
  end

  def sample_data_file
    'feed_xkcd.xml'
  end

  def expected
    NormalizedEntity.new(
      feed_id: feed.id,
      uid: 'http://xkcd.com/1732/',
      link: 'http://xkcd.com/1732/',
      published_at: DateTime.parse('2016-09-12 04:00:00 UTC'),
      text: 'Earth Temperature Timeline - http://xkcd.com/1732/',
      attachments: ['http://imgs.xkcd.com/comics/earth_temperature_timeline.png'],
      comments: ['[After setting your car on fire] Listen, your car\'s temperature has changed before.'],
      validation_errors: []
    )
  end

  def test_normalized_sample
    assert_equal(expected, normalized.first)
  end
end
