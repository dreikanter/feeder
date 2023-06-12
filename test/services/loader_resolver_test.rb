require "test_helper"

class LoaderResolverTest < Minitest::Test
  UNRESOLVABLE = "[unresolvable]".freeze
  URL = "https://example.com/feed".freeze

  def subject(attributes)
    LoaderResolver.call(Feed.new(attributes))
  end

  def test_default_fallback
    attributes = {}
    assert_equal(HttpLoader, subject(attributes))
  end

  def test_explicit_loader_name
    attributes = {loader: "twitter"}
    assert_equal(TwitterLoader, subject(attributes))
  end

  def test_null_loader
    attributes = {loader: "null"}
    assert_equal(NullLoader, subject(attributes))
  end

  def test_resolution_error
    attributes = {loader: UNRESOLVABLE}
    assert_raises(LoaderResolver::Error) { subject(attributes) }
  end
end
