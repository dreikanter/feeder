require 'test_helper'

class FeedsListTest < Minitest::Test
  def service
    Service::FeedsList
  end

  SAMPLE_CONFIG_PATH =
    File.expand_path(File.join(File.dirname(__FILE__), './feeds.yml')).freeze

  EXPECTED_DEFAULTS = {
    'after' => nil,
    'import_limit' => nil,
    'loader' => nil,
    'normalizer' => nil,
    'options' => {},
    'processor' => nil,
    'refresh_interval' => 0,
    'url' => nil
  }.freeze

  def test_happy_path
    result = Service::FeedsList.call(SAMPLE_CONFIG_PATH)
    expected = YAML.load_file(SAMPLE_CONFIG_PATH)
    expected = expected.map { |options| EXPECTED_DEFAULTS.merge(options) }
    assert_equal(expected, result)
  end

  def test_names
    feeds = Service::FeedsList.call(SAMPLE_CONFIG_PATH)
    result = feeds.map { |feed| feed['name'] }
    expected = YAML.load_file(SAMPLE_CONFIG_PATH).map { |feed| feed['name'] }
    assert_equal(expected, result)
  end
end
