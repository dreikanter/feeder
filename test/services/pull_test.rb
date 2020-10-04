require 'test_helper'
require_relative '../support/test_loader'
require_relative '../support/test_processor'
require_relative '../support/test_normalizer'
require_relative '../support/error_loader'
require_relative '../support/error_processor'
require_relative '../support/error_normalizer'

class PullTest < Minitest::Test
  def subject
    Pull
  end

  def feed
    create(:feed, name: :test, import_limit: 0)
  end

  def feed_with_error_loader
    create(:feed, name: :test, loader: :error)
  end

  def feed_with_error_processor
    create(:feed, name: :test, processor: :error)
  end

  def feed_with_error_normalizer
    create(:feed, name: :test, normalizer: :error)
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
    assert(entities)
    assert(entities.is_a?(Enumerable))
    assert_equal(expected_entities_count, entities.count)
  end

  def test_loader_error_bypass
    assert_raises(StandardError) { subject.call(feed_with_error_loader) }
  end

  def test_processor_error_bypass
    assert_raises(StandardError) { subject.call(feed_with_error_loader) }
  end

  def test_normalizer_error_bypass
    assert_raises(StandardError) { subject.call(feed_with_error_loader) }
  end
end
