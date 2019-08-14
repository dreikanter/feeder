require 'test_helper'

class FeedBuilderTest < Minitest::Test
  def subject
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
    }
  ].freeze

  def setup
    Feed.delete_all
    CONFIG.each { |feed| Feed.create!(**feed) }
  end

  def test_find
    CONFIG.map { |feed| feed[:name] }.each do |feed_name|
      feeds_list = Feed.all
      result = subject.call(feed_name, feeds_list: feeds_list)
      expected = Feed.find_by(name: feed_name)
      assert_equal(result, expected)
    end
  end

  def test_raise_when_feed_name_is_not_found
    not_existing_feed_name = '404'
    assert_raises(StandardError) { subject.call(not_existing_feed_name) }
  end
end
