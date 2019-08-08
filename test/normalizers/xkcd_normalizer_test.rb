require 'test_helper'
require_relative '../support/normalizer_test_helper'

class XkcdNormalizerTest < Minitest::Test
  include NormalizerTestHelper

  def subject
    Normalizers::XkcdNormalizer
  end

  def processor
    Processors::RssProcessor
  end

  def sample_data_file
    'feed_xkcd.xml'
  end

  def test_sample_data_file_exists
    assert(File.exist?(sample_data_path))
  end

  def test_have_sample_data
    assert(processed.present?)
    assert(processed.length.positive?)
  end

  def test_normalization
    assert(normalized.present?)
    assert_equal(processed.length, normalized.length)
  end

  FIRST_SAMPLE = {
    'uid' => 'http://xkcd.com/1732/',
    'link' => 'http://xkcd.com/1732/',
    'published_at' => Time.parse('2016-09-12 04:00:00 UTC'),
    'text' => 'Earth Temperature Timeline - http://xkcd.com/1732/',
    'attachments' => [
      'http://imgs.xkcd.com/comics/earth_temperature_timeline.png'
    ],
    'comments' => [
      '[After setting your car on fire] Listen, your car\'s ' \
      'temperature has changed before.'
    ]
  }.freeze

  def test_normalized_sample
    assert_equal(FIRST_SAMPLE, normalized.first.value!)
  end
end
