require 'test_helper'

class ProcessorResolverTest < Minitest::Test
  UNRESOLVABLE = 'unresolvable'.freeze

  def assert_resolve(expected, attributes)
    feed = Feed.new(attributes)
    result = Service::ProcessorResolver.call(feed)
    assert_equal(expected, result)
  end

  def test_explicit_resolution_for_rss
    attributes = { name: 'xkcd', processor: 'rss' }
    assert_resolve(Processors::RssProcessor, attributes)
  end

  def test_explicit_resolution_for_atom
    attributes = { name: 'dilbert', processor: 'atom' }
    assert_resolve(Processors::AtomProcessor, attributes)
  end

  def test_resolution_by_name
    attributes = { name: 'atom', processor: 'unresolvable' }
    assert_resolve(Processors::AtomProcessor, attributes)
  end

  def test_fallback
    attributes = { name: 'unresolvable', processor: 'unresolvable' }
    assert_resolve(Processors::NullProcessor, attributes)
  end
end
