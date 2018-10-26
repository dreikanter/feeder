require 'test_helper'

class ProcessorResolverTest < Minitest::Test
  SAMPLE_FEEDS = [
    {
      'name' => 'xkcd',
      'processor' => 'rss'
    },
    {
      'name' => 'dilbert',
      'processor' => 'atom'
    },
    {
      'name' => 'oglaf',
      'processor' => 'rss'
    },
    {
      'name' => 'null-sample'
    }
  ].freeze

  EXPECTED_PROCESSORS = {
    'xkcd' => Processors::RssProcessor,
    'dilbert' => Processors::AtomProcessor,
    'oglaf' => Processors::OglafProcessor,
    'null-sample' => Processors::NullProcessor
  }.freeze

  def test_happy_path
    Service::Feeds.load(SAMPLE_FEEDS)
    EXPECTED_PROCESSORS.each do |feed_name, expected|
      result = Service::ProcessorResolver.call(feed_name)
      assert_equal(result, expected)
    end
  end
end
