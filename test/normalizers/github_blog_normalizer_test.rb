require_relative 'normalizer_test'

class GithubBlogNormalizerTest < NormalizerTest
  SAMPLE_DATA_FILE = 'feed_github_blog.xml'.freeze

  SAMPLE_DATA_PATH =
    File.join(File.expand_path('../data', __dir__), SAMPLE_DATA_FILE).freeze

  def test_sample_data_file_exists
    assert(File.exist?(SAMPLE_DATA_PATH))
  end

  def process_sample_data
    source = File.read(SAMPLE_DATA_PATH)
    Processors::AtomProcessor.call(source)
  end

  def processed
    @processed ||= process_sample_data
  end

  def test_have_sample_data
    assert(processed.present?)
    assert(processed.length.positive?)
  end

  def normalize_sample_data
    processed.map do |entity|
      Normalizers::GithubBlogNormalizer.call(entity[1])
    end
  end

  def normalized
    @normalized ||= normalize_sample_data.compact
  end

  def test_normalization
    assert(normalized.present?)
    assert_equal(processed.length, normalized.length)
  end

  def test_all_attachment_urls_should_be_absolute
    attachments = normalized.map { |entity| entity.payload['attachments'] }
    attachments.flatten.compact.each do |uri|
      assert(Addressable::URI.parse(uri).absolute?)
    end
  end
end
