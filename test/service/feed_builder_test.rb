require 'test_helper'

class FeedBuilderTest < Minitest::Test
  def service
    Service::FeedBuilder
  end

  CONFIG = [
    {
      name: 'xkcd',
      url: 'http://xkcd.com/rss.xml',
      processor: 'rss',
      after: '2018-09-15T00:00:00+00:00'
    },
    {
      name: 'oglaf',
      url: 'http://oglaf.com/feeds/rss/',
      processor: 'oglaf',
      normalizer: 'oglaf',
      after: '2018-09-18T00:00:00+00:00'
    },
    {
      name: 'phdcomics',
      url: 'http://feeds.feedburner.com/PhdComics',
      processor: 'rss',
      after: '2018-09-18T00:00:00+00:00'
    }
  ].freeze

  def setup
    Feed.delete_all
  end

  def test_find
    CONFIG.map { |feed| feed[:name] }.each do |feed_name|
      fetcher = ->(name) { CONFIG.find { |feed| feed[:name] == name } }
      result = service.call(feed_name, fetcher)
      expected = Feed.find_by(name: feed_name)
      assert_equal(result, expected)
    end
  end
end
