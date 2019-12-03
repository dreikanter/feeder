require 'test_helper'

class FileDownloaderTest < Minitest::Test
  def subject
    FileDownloader
  end

  SAMPLE_URL = 'https://example.org'.freeze
  EXPECTED_CONTENT_TYPE = 'text/html; charset=UTF-8'.freeze
  CONTENT = '<html></html>'.freeze

  def setup
    stub_request(:get, SAMPLE_URL).to_return(
      body: CONTENT,
      headers: { 'Content-Type' => EXPECTED_CONTENT_TYPE }
    )
  end

  def test_download
    subject.call(SAMPLE_URL) do |file, content_type|
      assert_equal(CONTENT, file.read)
      assert_equal(EXPECTED_CONTENT_TYPE, content_type)
    end
  end
end
