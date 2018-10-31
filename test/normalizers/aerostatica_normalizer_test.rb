require_relative 'normalizer_test'

class AerostaticaNormalizerTest < NormalizerTest
  def sample_data_file
    'feed_aerostatica.xml'
  end

  def processor
    Processors::FeedjiraProcessor
  end

  def normalizer
    Normalizers::AerostaticaNormalizer
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

  # TODO: Use DI to test the normalizer offline
  # TODO: Test normalization result

  # FIRST_SAMPLE = {
  #   'link' => 'https://aerostatica.ru/2018/10/28/702-samhain-2018/',
  #   'published_at' => Time.parse('2018-10-28 11:10:00 UTC'),
  #   'text' =>
  #     'Samhain-2018 - https://aerostatica.ru/2018/10/28/702-samhain-2018/',
  #   'attachments' => [
  #     'http://feeds.feedburner.com/~r/aerostatica/~4/hlHtCxRsb5o'
  #   ],
  #   'comments' => []}
  # }.freeze

  # def test_normalized_sample
  #   assert_equal(FIRST_SAMPLE, normalized.first)
  # end
end
