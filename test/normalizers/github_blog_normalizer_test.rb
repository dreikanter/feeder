require_relative 'normalizer_test'

class GithubBlogNormalizerTest < NormalizerTest
  SAMPLE_DATA_FILE = 'feed_github_blog.xml'

  SAMPLE_DATA_PATH =
    File.join(File.expand_path('../../data', __FILE__), SAMPLE_DATA_FILE)

  def test_sample_data_file_exists
    assert File.exist?(open(SAMPLE_DATA_PATH))
  end

  def process_sample_data
    source = open(SAMPLE_DATA_PATH).read
    Processors::AtomProcessor.process(source)
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
      Normalizers::GithubBlogNormalizer.process(entity[1])
    end
  end

  def normalized
    @normalized ||= normalize_sample_data
  end

  def test_normalization
    assert normalized.present?
    assert processed.length == normalized.length
  end
end
