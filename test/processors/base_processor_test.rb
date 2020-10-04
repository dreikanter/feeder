require 'test_helper'

class BaseProcessorTest < Minitest::Test
  def subject
    BaseProcessor
  end

  ENTITIES = Array.new(1).fill { Object.new }.freeze

  def test_descendants_callable
    processor = Class.new(subject) {}
    assert(processor.respond_to?(:call))
  end

  def test_success
    processor = Class.new(subject) do
      define_method(:entities) { [] }
    end
    result = processor.call(Object.new, Feed.new)
    assert(result)
  end

  def test_failure
    processor = Class.new(subject) do
      define_method(:entities) { raise }
    end

    assert_raises(RuntimeError) { processor.call(nil, Feed.new) }
  end

  def test_returns_entities
    processor = Class.new(subject) do
      define_method(:entities) { ENTITIES }
    end

    result = processor.call(Object.new, Feed.new)
    assert_equal(ENTITIES, result)
  end

  def test_abstract_entities
    assert_raises(NotImplementedError) { subject.call(Object.new, Feed.new) }
  end
end
