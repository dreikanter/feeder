require 'test_helper'

class FeedsListTest < Minitest::Test
  def service
    Service::FeedsList
  end

  SAMPLE_CONFIG_PATH = File.expand_path('./feeds.yml', __dir__).freeze

  def test_happy_path
    result = Service::FeedsList.call(SAMPLE_CONFIG_PATH)
    expected = YAML.load_file(SAMPLE_CONFIG_PATH).map do |feed|
      Service::FeedSanitizer.call(feed.symbolize_keys)
    end
    assert_equal(expected, result)
  end

  def test_names
    feeds = Service::FeedsList.call(SAMPLE_CONFIG_PATH)
    result = feeds.map { |feed| feed['name'] }
    expected = YAML.load_file(SAMPLE_CONFIG_PATH).map { |feed| feed[:name] }
    assert_equal(expected, result)
  end

  def test_find_by_name
    feeds = Service::FeedsList.call(SAMPLE_CONFIG_PATH)
    feeds.each { |feed| assert(service[feed[:name]]) }
  end

  def test_not_found
    refute(Service::FeedsList[nil])
    refute(Service::FeedsList[''])
    refute(Service::FeedsList['!non-existing feed name!'])
  end
end
