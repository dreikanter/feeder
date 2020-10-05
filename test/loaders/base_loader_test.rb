require 'test_helper'

class BaseLoaderTest < Minitest::Test
  def subject
    BaseLoader
  end

  def feed
    build(:feed, name: SecureRandom.hex)
  end

  def test_success
    expected = Object.new
    loader = Class.new(subject) do
      define_method(:perform) { expected }
    end
    result = loader.call(feed)
    assert(result.success?)
    assert_equal(expected, result.value!)
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
