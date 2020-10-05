require 'test_helper'
require_relative '../support/test_loader'
require_relative '../support/test_processor'
require_relative '../support/test_normalizer'

class PullTest < Minitest::Test
  def subject
    Pull
  end

  def feed
    create(:feed, name: :test, import_limit: 0)
  end

  def test_loader
    result = LoaderResolver.call(feed)
    assert_equal(TestLoader, result)
  end

  def test_processor
    result = ProcessorResolver.call(feed)
    assert_equal(TestProcessor, result)
  end

  def test_normalizer
    result = NormalizerResolver.call(feed)
    assert_equal(TestNormalizer, result)
  end

  def test_call
    expected_entities_count = TestProcessor::ENTITIES.count
    entities = subject.call(feed)
    assert(entities.success?)
    assert(entities.value!.is_a?(Enumerable))
    assert_equal(expected_entities_count, entities.value!.count)
  end
end
