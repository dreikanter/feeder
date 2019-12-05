# frozen_string_literal: true

require 'test_helper'

class DownloaderTest < Minitest::Test
  def subject
    Downloader
  end

  SAMPLE_URL = 'https://placehold.it/1x1.png'
  CONTENT_TYPE = 'image/png'

  def setup
    stub_request(:get, SAMPLE_URL)
      .to_return(
        body: file_fixture('1x1.png'),
        headers: { 'Content-Type' => CONTENT_TYPE }
      )
  end

  def test_can_download
    subject.call(SAMPLE_URL) do |io, content_type|
      expected = file_fixture('1x1.png')
      expected.set_encoding(Encoding::BINARY)
      assert_equal(expected.read, io.read)
      assert_equal(CONTENT_TYPE, content_type)
    end
  end
end
