require 'test_helper'

module Processors
  class BaseTest < Minitest::Test
    def subject
      Processors::Base
    end

    ENTITIES = Array.new(1).fill { Object.new }.freeze

    def loader
      Class.new(subject) do
        define_method(:entities) { ENTITIES }
      end
    end

    def test_descendants_callable
      assert(loader.respond_to?(:call))
    end

    def test_success
      result = loader.call(Object.new, Feed.new)
      assert(result.success?)
    end

    def test_failure
      result = loader.call(nil)
      assert(result.failure?)
    end

    def test_returns_entities
      result = loader.call(Object.new, Feed.new).value!
      assert_equal(ENTITIES, result)
    end

    def test_abstract_entities
      assert_raises(NotImplementedError) { subject.call(Object.new, Feed.new) }
    end
  end
end
