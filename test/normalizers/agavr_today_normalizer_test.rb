require_relative 'normalizer_test'

class AgavrTodayNormalizerTest < NormalizerTest
  def sample_data_file
    'feed_agavr_today.xml'
  end

  def processor
    Processors::RssProcessor
  end

  def normalizer
    Normalizers::AgavrTodayNormalizer
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
    assert_equal(processed.length, normalized.length)
  end

  # TODO: Test normalization result
end
