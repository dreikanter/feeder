require 'test_helper'
require_relative '../support/test_loader.rb'
require_relative '../support/test_processor.rb'
require_relative '../support/test_normalizer.rb'

class PullTest < Minitest::Test
  def subject
    Pull
  end

  def feed
    build(:feed, name: :test, import_limit: 0)
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

  def test_requires_feed_param
    assert_raises(ArgumentError) { subject.call }
  end

  def test_call
    expected_entities_count = TestProcessor::ENTITIES.count
    posts = subject.call(feed)
    assert(posts.is_a?(Enumerable))
    assert_equal(expected_entities_count, posts.count)
  end
end
