require 'test_helper'

class FeedsTest < ActiveSupport::TestCase
  SAMPLE_FEEDS = [
    {
      'name' => 'xkcd',
      'url' => 'http://xkcd.com/rss.xml',
      'processor' => 'rss'
    },
    {
      'name' => 'dilbert',
      'url' => 'http://dilbert.com/feed',
      'processor' => 'atom'
    },
    {
      'name' => 'phdcomics',
      'url' => 'http://feeds.feedburner.com/PhdComics',
      'processor' => 'rss'
    },
    {
      'name' => 'commitstrip',
      'url' => 'https://www.commitstrip.com/en/feed/',
      'processor' => 'rss'
    }
  ].freeze

  def sample_index
    @sample_index ||= Service::Feeds.index(SAMPLE_FEEDS)
  end

  def sample_feed
    @sample_feed ||= SAMPLE_FEEDS.first
  end

  def sample_feed_name
    @sample_feed_name ||= sample_feed['name']
  end


  def test_index_is_enumerable
    assert sample_index.kind_of?(Enumerable)
  end

  def test_index_count
    assert_equal sample_index.count, SAMPLE_FEEDS.count
  end

  def test_find_present
    assert Service::Feeds.find(sample_feed_name, SAMPLE_FEEDS).present?
  end

  def test_find_match
    result = Service::Feeds.find(sample_feed_name, SAMPLE_FEEDS)
    assert_equal result, OpenStruct.new(sample_feed)
  end
end
