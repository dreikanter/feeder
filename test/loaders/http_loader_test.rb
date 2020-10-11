require 'test_helper'

class HttpLoaderTest < Minitest::Test
  def subject
    HttpLoader
  end

  def loader_call
    subject.call(feed)
  end

  def feed
    build(:feed, name: SecureRandom.hex)
  end

  EXPECTED = {}.to_json

  def test_fetch_http_url
    stub_request(:get, feed.url).to_return(body: EXPECTED)
    assert_equal(EXPECTED, loader_call)
  end

  def test_bypass_http_client_error
    stub_request(:get, feed.url).to_raise(StandardError)
    assert_raises(StandardError) { loader_call }
  end

  def test_requires_feed_url
    feed = build(:feed, url: nil)
    assert_raises(ArgumentError) { subject.call(feed) }
  end
end
