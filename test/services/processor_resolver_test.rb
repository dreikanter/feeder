require 'test_helper'

class ProcessorResolverTest < Minitest::Test
  UNRESOLVABLE = 'unresolvable'.freeze

  def subject
    ProcessorResolver
  end

  def test_callable
    assert(subject.respond_to?(:call))
  end

  def test_explicit_resolution_for_rss
    feed = build(:feed, name: 'xkcd', processor: 'rss')
    assert_equal(RssProcessor, subject.call(feed))
  end

  def test_explicit_resolution_for_atom
    feed = build(:feed, name: 'dilbert', processor: 'atom')
    assert_equal(AtomProcessor, subject.call(feed))
  end

  def test_resolution_by_name
    feed = build(:feed, name: 'atom', processor: 'unresolvable')
    assert_equal(AtomProcessor, subject.call(feed))
  end

  def test_fallback
    feed = build(:feed, name: 'unresolvable', processor: 'unresolvable')
    assert_equal(NullProcessor, subject.call(feed))
  end
end
