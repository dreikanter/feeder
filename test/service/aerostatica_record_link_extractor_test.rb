require 'test_helper'

class AerostaticaRecordLinkExtractorTest < Minitest::Test
  def subject
    Service::AerostaticaRecordLinkExtractor
  end

  SAMPLE_DATA_FILE = 'post_aerostatica.html'.freeze

  SAMPLE_DATA_PATH = File.join(
    File.expand_path('../data', __dir__),
    SAMPLE_DATA_FILE
  ).freeze

  EXPECTED = 'https://aerostatica.ru/music/702.mp3'.freeze

  def test_happy_path
    content = File.read(SAMPLE_DATA_PATH)
    result = subject.call(content)
    assert_equal(EXPECTED, result)
  end
end
