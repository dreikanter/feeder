require 'test_helper'

class FeedNamesTest < Minitest::Test
  def service
    Service::FeedNames
  end

  def test_return_name_attribute_values
    names = (0..1).map { |index| "feed#{index}" }
    feeds_list = -> { names.map { |feed_name| Feed.new(name: feed_name) } }
    result = service.call(feeds_list: feeds_list)
    assert_equal(names, result)
  end
end
