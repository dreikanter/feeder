require 'test_helper'

class EntityNormalizerTest < ActiveSupport::TestCase
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
      'name' => 'processor-name-example',
      'url' => 'http://example.com/feed',
      'processor' => 'rss'
    },
    {
      'name' => 'livejournal-example',
      'url' => 'http://example.livejournal.com/data/rss',
      'processor' => 'rss',
      'normalizer' => 'livejournal'
    },
    {
      'name' => 'medium-example',
      'url' => 'https://medium.com/feed/@example',
      'processor' => 'rss',
      'normalizer' => 'medium'
    }
  ].freeze

  SAMPLE_NO_MATCH = {
    'name' => 'null-example',
    'url' => 'http://example.com/feed'
  }.freeze

  EXPECTED_NORMALIZERS = {
    'xkcd' => EntityNormalizers::XkcdNormalizer,
    'dilbert' => EntityNormalizers::DilbertNormalizer,
    'processor-name-example' => EntityNormalizers::RssNormalizer,
    'livejournal-example' => EntityNormalizers::LivejournalNormalizer,
    'medium-example' => EntityNormalizers::MediumNormalizer
  }.freeze

  def test_for
    EXPECTED_NORMALIZERS.each do |feed_name, normalizer_class|
      result = Service::EntityNormalizer.for(feed_name, SAMPLE_FEEDS)
      assert_equal result, normalizer_class
    end
  end

  def test_no_matches
    assert_raises do
      Service::EntityNormalizer.for(SAMPLE_NO_MATCH)
    end
  end
end
