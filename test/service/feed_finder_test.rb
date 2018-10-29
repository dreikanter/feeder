require 'test_helper'

class FeedFinderTest < Minitest::Test
  def service
    Service::FeedFinder
  end

  SAMPLE_CONFIG_PATH =
    File.expand_path(File.join(File.dirname(__FILE__), './feeds.yml')).freeze

  def test_sample_config_exists
    message = "#{SAMPLE_CONFIG_PATH} should exist"
    assert(File.exists?(SAMPLE_CONFIG_PATH), message)
  end

  def test_find
    Service::FeedsList.load_config(SAMPLE_CONFIG_PATH)
    Service::FeedsList.names.each do |name|
      result = service.call(name)
      expected = Feed.find_by(name: name)
      assert_equal(result, expected)
    end
  end
end
