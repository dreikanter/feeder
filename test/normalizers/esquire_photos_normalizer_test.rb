require_relative 'normalizer_test'

class EsquirePhotosNormalizerTest < NormalizerTest
  SAMPLE_DATA_FILE = 'feed_esquire-photos.xml'

  SAMPLE_DATA_PATH =
    File.join(File.expand_path('../../data', __FILE__), SAMPLE_DATA_FILE)

  def test_sample_data_file_exists
    assert File.exist?(open(SAMPLE_DATA_PATH))
  end

  def process_sample_data
    source = open(SAMPLE_DATA_PATH).read
    Processors::RssProcessor.process(source)
  end

  def processed
    @processed ||= process_sample_data
  end

  def test_have_sample_data
    assert processed.present?
    assert processed.length > 0
  end

  def normalize_sample_data
    processed.map do |entity|
      Normalizers::EsquirePhotosNormalizer.process(entity[1])
    end
  end

  def normalized
    @normalized ||= normalize_sample_data
  end

  def test_normalization
    assert normalized.present?
    assert processed.length == normalized.length
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
  }

  def test_normalized_sample
    assert normalized.first == FIRST_SAMPLE
  end
end
