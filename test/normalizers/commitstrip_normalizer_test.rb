require_relative 'normalizer_test'

class CommitstripNormalizerTest < NormalizerTest
  SAMPLE_DATA_FILE = 'feed_commitstrip.xml'

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
      Normalizers::CommitstripNormalizer.process(entity[1])
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
    "link" => "https://www.commitstrip.com/2017/09/19/the-whole-teams-working-on-it/",
    "published_at" => DateTime.parse('2017-09-19 16:42:52 +0000'),
    "text" => "The whole team’s working on it - https://www.commitstrip.com/2017/09/19/the-whole-teams-working-on-it/",
    "attachments" => ["https://www.commitstrip.com/wp-content/uploads/2017/09/Strip-La-super-équipe-de-maintenance-650-finalenglish.jpg"],
    "comments" => []
  }

  def test_normalized_sample
    assert normalized.first == FIRST_SAMPLE
  end
end
