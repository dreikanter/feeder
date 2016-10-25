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

  def test_index_count
    assert_equal Service::Feeds.count, SAMPLE_FEEDS.count
  end

  def test_find_present
    Service::Feeds.load(SAMPLE_FEEDS)
    SAMPLE_FEEDS.map { |f| f['name'] }.each do |name|
      assert Service::Feeds.find(name).present?
    end
  end
end
