require 'test_helper'

class FeedProcessorTest < Minitest::Test
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
      'name' => 'oglaf',
      'url' => 'http://oglaf.com/feeds/rss/',
      'processor' => 'rss'
    },
    {
      'name' => 'null-sample',
      'url' => 'http://example.com/feed'
    }
  ].freeze

  EXPECTED_PROCESSORS = {
    'xkcd' => Processors::RssProcessor,
    'dilbert' => Processors::AtomProcessor,
    'oglaf' => Processors::OglafProcessor,
    'null-sample' => Processors::NullProcessor
  }.freeze

  def test_for
    Service::Feeds.load(SAMPLE_FEEDS)
    EXPECTED_PROCESSORS.each do |feed_name, processor_class|
      result = Service::FeedProcessor.for(feed_name)
      assert_equal result, processor_class
    end
  end
end
