require 'test_helper'

class BaseLoaderTest < Minitest::Test
  def subject
    BaseLoader
  end

  def feed
    build(:feed, name: SecureRandom.hex)
  end

  def test_require_feed_argument
    loader = Class.new(subject)
    assert_raises(NotImplementedError) { loader.call(feed) }
  end

  def test_success
    expected = Object.new
    loader = Class.new(subject) do
      define_method(:perform) { expected }
    end
    result = loader.call(feed)
    assert(result)
    assert_equal(expected, result)
  end

  def test_failure
    loader = Class.new(subject) do
      define_method(:perform) { raise }
    end
    result = loader.call(feed)
    assert(result.failure?)
    assert(result.failure.is_a?(RuntimeError))
  end
end
