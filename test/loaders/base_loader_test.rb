require 'test_helper'

module Loaders
  class BaseLoaderTest < Minitest::Test
    def subject
      Loaders::Base
    end

    def sample_feed
      @sample_feed ||= create(:feed)
    end

    def test_require_feed_argument
      loader = Class.new(subject)
      assert_raises(NotImplementedError) { loader.call(sample_feed) }
    end

    def test_success
      expected = Object.new
      loader = Class.new(subject) do
        define_method(:perform) { expected }
      end
      result = loader.call(sample_feed)
      assert(result.success?)
      assert_equal(expected, result.value!)
    end

    def test_failure
      loader = Class.new(subject) do
        define_method(:perform) { raise }
      end
      result = loader.call(sample_feed)
      assert(result.failure?)
      assert(result.failure.is_a?(RuntimeError))
    end
  end
end
