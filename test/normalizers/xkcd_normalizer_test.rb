require_relative 'normalizer_test'

class XkcdNormalizerTest < NormalizerTest
  def sample_data_file
    'feed_xkcd.xml'
  end

  def processor
    Processors::RssProcessor
  end

  def normalizer
    Normalizers::XkcdNormalizer
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
  }

  def test_normalized_sample
    assert_equal(FIRST_SAMPLE, normalized.first)
  end
end
