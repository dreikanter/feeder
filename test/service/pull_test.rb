require 'test_helper'

class PullTest < Minitest::Test
  def test_requires_feed_param
    assert_raises { Service::Pull.call }
  end

  NON_EXISTING_FEED_NAME = '!!bananas!!'.freeze

  def test_requires_existing_feed
    feed = Feed.new(name: NON_EXISTING_FEED_NAME)
    assert_raises { Service::Pull.call(feed) }
  end
end
