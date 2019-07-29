require 'test_helper'

class NormalizerResolverTest < Minitest::Test
  UNRESOLVABLE = 'unresolvable'.freeze

  def service
    Service::NormalizerResolver
  end

  def test_callable
    assert(service.respond_to?(:call))
  end

  def test_explicit_resolution_for_rss
    feed = build(:feed, name: 'xkcd', normalizer: 'rss')
    assert_equal(Normalizers::RssNormalizer, service.call(feed))
  end

  def test_explicit_resolution_for_atom
    feed = build(:feed, name: 'dilbert', normalizer: 'atom')
    assert_equal(Normalizers::AtomNormalizer, service.call(feed))
  end

  def test_resolution_by_name
    feed = build(:feed, name: 'atom', normalizer: UNRESOLVABLE)
    assert_equal(Normalizers::AtomNormalizer, service.call(feed))
  end

  def test_resolution_error
    feed = build(:feed, name: UNRESOLVABLE, normalizer: UNRESOLVABLE)
    assert_raises(StandardError) do
      service.call(feed)
    end
  end
end
