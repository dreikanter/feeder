require_relative 'normalizer_test'

class PoorlydrawnlinesNormalizerTest < NormalizerTest
  def sample_data_file
    'feed_poorlydrawnlines.xml'
  end

  def processor
    Processors::FeedjiraProcessor
  end

  def normalizer
    Normalizers::PoorlydrawnlinesNormalizer
  end

  def test_sample_data_file_exists
    assert File.exist?(sample_data_path)
  end

  def test_have_sample_data
    assert(processed.present?)
    assert(processed.length.positive?)
  end

  def test_normalization
    assert(normalized.present?)
    assert(processed.length == normalized.length)
  end

  FIRST_SAMPLE = {
    'link' => 'http://www.poorlydrawnlines.com/comic/hello/',
    'published_at' => Time.parse('2018-10-22 16:03:51 UTC'),
    'text' => 'Hello - http://www.poorlydrawnlines.com/comic/hello/',
    'attachments' => ['http://www.poorlydrawnlines.com/wp-content/uploads/2018/10/hello.png'],
    'comments' => []
  }.freeze

  def test_normalized_sample
    assert_equal(FIRST_SAMPLE, normalized.first)
  end
end
