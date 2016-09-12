require "test_helper"

class FeedTest < ActiveSupport::TestCase
  def feed
    @feed ||= Feed.new
  end

  def test_valid
    assert feed.valid?
  end
end
