require 'test_helper'

module Service
  class FeedSanitizerTest < Minitest::Test
    def service
      Service::FeedSanitizer
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

    def test_return_hash
      result = service.call(SAMPLE_FEED)
      assert(result.is_a?(Hash))
    end

    def test_require_name
      feed = SAMPLE_FEED.except(:name)
      assert_raises(KeyError) { service.call(feed) }
    end

    def test_require_only_name
      feed = SAMPLE_FEED.slice(:name)
      service.call(feed)
    end

    def test_parse_after
      result = service.call(SAMPLE_FEED)[:after]
      assert(result.is_a?(DateTime))
    end

    def test_parse_integers
      result = service.call(SAMPLE_FEED)
      assert(result[:import_limit].is_a?(Integer))
      assert(result[:refresh_interval].is_a?(Integer))
    end
  end
end
