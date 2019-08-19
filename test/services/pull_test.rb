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

  def test_resolve_loader
    result = LoaderResolver.call(feed)
    assert_equal(TestLoader, result)
  end

  def test_resolve_processor
    result = ProcessorResolver.call(feed)
    assert_equal(TestProcessor, result)
  end

  def test_resolve_normalizer
    result = NormalizerResolver.call(feed)
    assert_equal(TestNormalizer, result)
  end

  SAMPLE_CONTENT = 'sample content'.freeze
  SAMPLE_ENTITIES = [].freeze
  SAMPLE_NORMALIZED_ENTITIES = [].freeze
  SAMPLE_UID = Object.new.freeze

  NORMALIZED_ENTITY = {
    uid: nil,
    link: nil,
    published_at: nil,
    text: nil,
    attachments: [],
    comments: []
  }.freeze

  def loader(expected_result)
    Class.new(BaseLoader) do
      define_method(:perform) { result }
    end
  end

  def test_loader
    result = loader(SAMPLE_CONTENT).call(feed)
    assert(result.success?)
    assert_equal(SAMPLE_CONTENT, result.value!)
  end

  def processor(expected_result)
    Class.new(BaseProcessor) do
      define_method('entities') { expected_result }
    end
  end

  def test_processor
    result = processor(SAMPLE_ENTITIES).call(nil, feed)
    assert(result.success?)
    assert_equal(SAMPLE_ENTITIES, result.value!)
  end

  def normalizer(expected_result)
    Class.new(BaseNormalizer) do
      define_method('perform') { expected_result }
    end
  end

  def test_normalizer
    result = normalizer(SAMPLE_ENTITY).call(nil, nil, feed)
    assert(result.success?)
    assert_equal(SAMPLE_ENTITY, result.value!)
  end
end
