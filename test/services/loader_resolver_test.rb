require 'test_helper'

class LoaderResolverTest < Minitest::Test
  UNRESOLVABLE = 'unresolvable'.freeze

  def assert_resolve(expected, attributes)
    feed = Feed.new(attributes)
    result = LoaderResolver.call(feed)
    assert_equal(expected, result)
  end

  DEFAULT_LOADER = HttpLoader

  def test_default_loader_resolution
    attributes = {}
    assert_resolve(DEFAULT_LOADER, attributes)
  end

  def test_resolution_by_loader_name
    attributes = { loader: 'twitter' }
    assert_resolve(TwitterLoader, attributes)
  end

  def test_resolution_by_feed_name
    attributes = { name: 'twitter' }
    assert_resolve(TwitterLoader, attributes)
  end

  def test_loader_name_should_prevail_over_feed_name
    attributes = { name: UNRESOLVABLE, loader: 'twitter' }
    assert_resolve(TwitterLoader, attributes)
  end

  def test_fallback
    attributes = { name: UNRESOLVABLE, loader: UNRESOLVABLE }
    assert_resolve(DEFAULT_LOADER, attributes)
  end
end
