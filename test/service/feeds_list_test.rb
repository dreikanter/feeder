require 'test_helper'

class FeedsListTest < Minitest::Test
  def service
    Service::FeedsList
  end

  SAMPLE_CONFIG_PATH =
    File.expand_path(File.join(File.dirname(__FILE__), './feeds.yml')).freeze

  def test_load_config
    Service::FeedsList.load_config(SAMPLE_CONFIG_PATH)
    result = Service::FeedsList.call
    expected = YAML.load_file(SAMPLE_CONFIG_PATH)
    assert_equal(expected, result)
  end

  def test_names
    Service::FeedsList.load_config(SAMPLE_CONFIG_PATH)
    result = Service::FeedsList.names
    expected = YAML.load_file(SAMPLE_CONFIG_PATH).map { |feed| feed['name'] }
    assert_equal(expected, result)
  end
end
