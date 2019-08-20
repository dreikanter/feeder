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

  def test_requires_feed_param
    assert_raises(ArgumentError) { subject.call }
  end

  def test_resolve_support_loader
    result = LoaderResolver.call(feed)
    assert_equal(TestLoader, result)
  end

  def test_resolve_support_processor
    result = ProcessorResolver.call(feed)
    assert_equal(TestProcessor, result)
  end

  def test_resolve_support_normalizer
    result = NormalizerResolver.call(feed)
    assert_equal(TestNormalizer, result)
  end

  def test_handle_loader_resolution_error
    # TODO
  end

  def test_handle_processor_resolution_error
    # TODO
  end

  def test_handle_normalization_resolution_error
    # TODO
  end

  def test_handle_loader_error
    loader = Class.new(BaseLoader) { define_method(:perform) { raise } }
    result = subject.call(feed, loader: loader)
    assert(result.failure?)
  end

  def test_handle_processor_error
    processor = Class.new(BaseProcessor) { define_method(:entities) { raise } }
    result = subject.call(feed, processor: processor)
    assert(result.failure?)
  end

  def test_handle_normalization_error
    norm = Class.new(BaseNormalizer) { define_method(:link) { raise } }
    result = subject.call(feed, normalizer: norm)
    assert(result.success?)
    assert(result.value!.all?(&:failure?))
  end

  SOME_ERRORS = ['some errors'].freeze

  def test_handle_validation_error
    norm = Class.new(BaseNormalizer) do
      define_method(:validation_errors) { SOME_ERRORS }
    end
    result = subject.call(feed, normalizer: norm)
    assert(result.success?)
    assert(result.value!.all?(&:failure?))
  end

  def test_happy_path
    result = subject.call(feed)
    assert(result.success?)
    assert(result.value!.all?(&:success?))
  end
end
