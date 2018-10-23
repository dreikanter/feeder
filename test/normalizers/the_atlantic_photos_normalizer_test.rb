require_relative 'normalizer_test'

class TheAtlanticPhotosNormalizer < NormalizerTest
  SAMPLE_DATA_FILE = 'feed_the_atlantic_photos.xml'

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
      Normalizers::TheAtlanticPhotosNormalizer.process(entity[1])
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
    'link' => 'http://feedproxy.google.com/~r/theatlantic/infocus/~3/5PMsxSsNGFk/',
    'published_at' => DateTime.parse('2017-09-19 14:15:30 -0400'),
    'text' => 'Yellowstone National Park, now 145 years old, was the first national park established in the world. In 2016, the 2.2-million-acre park was visited by a record 4.2 million people, who came to experience the wilderness, explore countless geothermal features, witness the gorgeous vistas, and try to catch a glimpse of the resident wildlife. Gathered here are a handful of compelling photos from Yellowstone’s past, as... (continued) - https://www.theatlantic.com/photo/2017/09/a-photo-trip-through-yellowstone-national-park/540339/',
    'attachments' => [
      'https://cdn.theatlantic.com/assets/media/img/photo/2017/09/a-photo-trip-through-yellowstone-na/y01_WY09022006/main_1200.jpg?1505843933'
    ],
    'comments' => [
      'The Lower Falls of the Yellowstone River, in Yellowstone National Park, photographed on September 2, 2006. (Stewart Tomlinson / U.S. Geological Survey)'
    ]
  }

  def test_normalized_sample
    assert normalized.first == FIRST_SAMPLE
  end
end
