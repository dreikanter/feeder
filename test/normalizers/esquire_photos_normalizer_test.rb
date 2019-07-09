require_relative 'normalizer_test'

class EsquirePhotosNormalizerTest < NormalizerTest
  SAMPLE_DATA_FILE = 'feed_esquire-photos.xml'.freeze

  SAMPLE_DATA_PATH =
    File.join(File.expand_path('../data', __dir__), SAMPLE_DATA_FILE).freeze

  def test_sample_data_file_exists
    assert(File.exist?(SAMPLE_DATA_PATH))
  end

  def process_sample_data
    source = File.read(SAMPLE_DATA_PATH)
    Processors::RssProcessor.call(source)
  end

  def processed
    @processed ||= process_sample_data
  end

  def test_have_sample_data
    assert(processed.present?)
    assert(processed.any?)
  end

  def normalize_sample_data
    processed.map do |entity|
      Normalizers::EsquirePhotosNormalizer.call(entity[1])
    end
  end

  def normalized
    @normalized ||= normalize_sample_data
  end

  def test_normalization
    assert(normalized.present?)
    assert_equal(processed.length, normalized.length)
  end

  FIRST_SAMPLE = {
    'link' => 'https://esquire.ru/escobar-netflix',
    'published_at' => nil,
    'text' => 'Брат Пабло Эскобара требует с Netflix миллиард долларов - https://esquire.ru/escobar-netflix',
    'attachments' =>
      [
        'https://images.esquire.ru/files/cache/images/f7/16/4572a4a1.crop1200x628x0x12-fit705x705.9f0ac3.TASS_23154406.jpg'
      ],
    'comments' => [
      '«Если мы не получим деньги, то прикроем их маленькое шоу».'
    ]
  }.freeze

  def test_normalized_sample
    assert_equal(FIRST_SAMPLE, normalized.first.payload)
  end
end
