require "test_helper"

class NormalizerResolverTest < Minitest::Test
  UNRESOLVABLE = "unresolvable".freeze

  def subject
    NormalizerResolver
  end

  def test_callable
    assert(subject.respond_to?(:call))
  end

  def test_explicit_resolution_for_rss
    feed = build(:feed, name: "xkcd", normalizer: "rss")
    assert_equal(RssNormalizer, subject.call(feed))
  end

  def test_explicit_resolution_for_atom
    feed = build(:feed, name: "dilbert", normalizer: "atom")
    assert_equal(AtomNormalizer, subject.call(feed))
  end

  def test_resolution_by_name
    feed = build(:feed, name: "atom", normalizer: UNRESOLVABLE)
    assert_equal(AtomNormalizer, subject.call(feed))
  end

  def test_resolution_error
    feed = build(:feed, name: UNRESOLVABLE, normalizer: UNRESOLVABLE)
    assert_raises(StandardError) do
      subject.call(feed)
    end
  end
end
