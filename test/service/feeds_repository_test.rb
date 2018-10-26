require 'test_helper'

class FeedRepositoryTest < Minitest::Test
  def service
    Service::FeedsRepository
  end

  SAMPLE_CONFIG_PATH = File.expand_path(File.join(
    File.dirname(__FILE__),
    './feeds_repository_test.yml'
  )).freeze

  def test_sample_config_exists
    message = "#{SAMPLE_CONFIG_PATH} should exist"
    assert(File.exists?(SAMPLE_CONFIG_PATH), message)
  end

  EXPECTED_NAMES = %w[xkcd oglaf phdcomics].freeze

  def test_load_config
    service.load_config(SAMPLE_CONFIG_PATH)
    names = service.feeds.map(&:name)
    assert_equal(EXPECTED_NAMES, names)
  end

  def test_create_feeds
    service.load_config(SAMPLE_CONFIG_PATH)
    service.feeds.each do |feed|
      assert(feed.persisted?)
    end
  end
end
