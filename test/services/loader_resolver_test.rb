require 'test_helper'

class LoaderResolverTest < Minitest::Test
  UNRESOLVABLE = 'unresolvable'.freeze
  URL = 'https://example.com/feed'.freeze

  def subject(attributes)
    LoaderResolver.call(Feed.new(attributes))
  end

  def test_default_loader_resolution
    attributes = { url: URL }
    assert_equal(HttpLoader, subject(attributes))
  end

  def test_resolution_by_loader_name
    attributes = { url: URL, loader: 'twitter' }
    assert_equal(TwitterLoader, subject(attributes))
  end

  def test_resolution_by_feed_name
    attributes = { url: URL, name: 'twitter' }
    assert_equal(TwitterLoader, subject(attributes))
  end

  def test_loader_name_should_prevail_over_feed_name
    attributes = { url: URL, name: UNRESOLVABLE, loader: 'twitter' }
    assert_equal(TwitterLoader, subject(attributes))
  end

  def test_fallback
    attributes = { url: URL, name: UNRESOLVABLE, loader: UNRESOLVABLE }
    assert_equal(HttpLoader, subject(attributes))
  end

  def test_null_loader_when_no_url
    attributes = { url: nil }
    assert_equal(NullLoader, subject(attributes))
  end

  def test_null_loader_overrides_feed_loader
    attributes = { url: nil, loader: 'http' }
    assert_equal(NullLoader, subject(attributes))
  end
end
