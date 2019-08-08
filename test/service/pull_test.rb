require 'test_helper'
require_relative '../support/test_loader.rb'
require_relative '../support/test_processor.rb'
require_relative '../support/test_normalizer.rb'

class PullTest < Minitest::Test
  def subject
    Service::Pull
  end

  def feed
    create(:feed, name: :test, import_limit: 0)
  end

  def test_loader
    result = Service::LoaderResolver.call(feed)
    assert_equal(Loaders::TestLoader, result)
  end

  def test_processor
    result = Service::ProcessorResolver.call(feed)
    assert_equal(Processors::TestProcessor, result)
  end

  def test_normalizer
    result = Service::NormalizerResolver.call(feed)
    assert_equal(Normalizers::TestNormalizer, result)
  end

  def test_requires_feed_param
    assert_raises(ArgumentError) { subject.call }
  end

  def test_call
    expected_entities_count = Processors::TestProcessor::ENTITIES.count
    posts = subject.call(feed)
    assert(posts.is_a?(Enumerable))
    assert_equal(expected_entities_count, posts.count)
  end
end
