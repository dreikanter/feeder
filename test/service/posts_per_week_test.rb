require 'test_helper'

class PostsPerWeekTest < Minitest::Test
  def service
    Service::PostsPerWeek
  end

  def feed
    @feed ||= create(:feed)
  end

  AMOUNT_OF_DAYS = 3
  POSTS_PER_DAY = 1
  DELTA = 0.001

  def test_calculates_posts_per_week
    AMOUNT_OF_DAYS.times do |offset|
      POSTS_PER_DAY.times do
        create(:post, feed: feed, published_at: offset.days.ago)
      end
    end

    result = service.call(feed)
    expected = POSTS_PER_DAY * service::DAYS_IN_A_WEEK
    assert_in_delta(expected, result, DELTA)
  end

  def test_can_handle_empty_feed
    result = service.call(feed)
    assert_in_delta(0, result, DELTA)
  end

  def test_should_return_zero_for_recently_inactive_feed
    published_at = service::HISTORY_DEPTH.days.ago
    create(:post, feed: feed, published_at: published_at)
    result = service.call(feed)
    assert_in_delta(0, result, DELTA)
  end

  def test_should_count_each_post_after_date_threshold
    published_at = service::HISTORY_DEPTH.days.ago + 1.second
    create(:post, feed: feed, published_at: published_at)
    result = service.call(feed)
    assert(result.positive?)
  end
end
