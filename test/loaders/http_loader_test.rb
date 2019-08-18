require 'test_helper'

class HttpLoaderTest < Minitest::Test
  def subject
    HttpLoader
  end

  def sample_feed
    create(:feed)
  end

  def test_call_client
    expected = Object.new
    client = ->(_url) {}
    client.expects(:call).returns(expected)
    result = subject.call(sample_feed, client: client)
    assert_equal(expected, result.value!)
  end

  def test_success
    client = ->(_url) {}
    result = subject.call(sample_feed, client: client)
    assert(result.success?)
  end

  def test_failure
    client = ->(_url) { raise }
    result = subject.call(sample_feed, client: client)
    assert(result.failure?)
  end

  def test_default_client_should_raise_on_empty_url
    feed = create(:feed, url: nil)
    result = subject.call(feed)
    assert(result.failure?)
  end
end
