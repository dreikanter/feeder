require 'test_helper'

class FeedSanitizerTest < Minitest::Test
  def subject
    FeedSanitizer
  end

  SAMPLE_FEED = {
    name: 'xkcd',
    after: 'Tue, 18 Sep 2018 00:00:00 +0000',
    import_limit: 10,
    normalizer: 'xkcd',
    options: {},
    processor: 'xkcd',
    url: 'http://xkcd.com/rss.xml',
    refresh_interval: 1800
  }.freeze

  MINIMAL_FEED = {
    name: 'dilbert'
  }.freeze

  def test_return_hash
    result = subject.call(**SAMPLE_FEED)
    assert(result.is_a?(Hash))
  end

  def test_require_name
    feed = SAMPLE_FEED.except(:name)
    assert_raises(KeyError) { subject.call(**feed) }
  end

  def test_minimal_configuration
    subject.call(**MINIMAL_FEED)
  end

  def test_parse_after
    result = subject.call(**SAMPLE_FEED)[:after]
    assert(result.is_a?(DateTime))
  end

  def test_parse_integers
    result = subject.call(**SAMPLE_FEED)
    assert(result[:import_limit].is_a?(Integer))
    assert(result[:refresh_interval].is_a?(Integer))
  end

  def test_omit_undefined_attrubutes
    result = subject.call(**MINIMAL_FEED)
    MINIMAL_FEED.each do |key, value|
      assert_equal(value, result[key])
    end
  end
end
