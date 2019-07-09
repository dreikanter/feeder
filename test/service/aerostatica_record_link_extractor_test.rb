require 'test_helper'

class AerostaticaRecordLinkExtractorTest < Minitest::Test
  def service
    Service::AerostaticaRecordLinkExtractor
  end

  SAMPLE_DATA_FILE = 'aerostatica_post.html'.freeze

  SAMPLE_DATA_PATH =
    File.join(File.expand_path('../../data', __FILE__), SAMPLE_DATA_FILE).freeze

  def test_sample_data_file_exists
    assert(File.exist?(SAMPLE_DATA_PATH))
  end

  EXPECTED = 'https://aerostatica.ru/music/702.mp3'.freeze

  def test_happy_path
    content = open(SAMPLE_DATA_PATH).read
    result = service.call(content)
    assert_equal(EXPECTED, result)
  end
end
