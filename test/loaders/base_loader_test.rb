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
    assert_equal(expected, result)
  end

  def test_failure
    loader = Class.new(subject) do
      define_method(:perform) { raise }
    end

    assert_raises(RuntimeError) { loader.call(feed) }
  end
end
