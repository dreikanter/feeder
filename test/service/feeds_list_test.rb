require 'test_helper'

class FeedsListTest < Minitest::Test
  def service
    Service::FeedsList
  end

  SAMPLE_CONFIG_PATH =
    File.expand_path(File.join(File.dirname(__FILE__), './feeds.yml')).freeze

  EXPECTED_NAMES = %w[xkcd oglaf phdcomics].freeze

  def test_load_config
    Service::FeedsList.load_config(SAMPLE_CONFIG_PATH)
    result = Service::FeedsList.call
    assert_equal(EXPECTED_NAMES, result)
  end
end
