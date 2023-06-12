# == Schema Information
#
# Table name: feeds
#
#  id                   :integer          not null, primary key
#  name                 :string           not null
#  posts_count          :integer          default(0), not null
#  refreshed_at         :datetime
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  url                  :string
#  processor            :string
#  normalizer           :string
#  after                :datetime
#  refresh_interval     :integer          default(0), not null
#  options              :json             not null
#  loader               :string
#  import_limit         :integer
#  last_post_created_at :datetime
#  subscriptions_count  :integer          default(0), not null
#  status               :integer          default("inactive"), not null
#
# Indexes
#
#  index_feeds_on_name    (name) UNIQUE
#  index_feeds_on_status  (status)
#

require "test_helper"

class FeedTest < Minitest::Test
  def subject
    Feed
  end

  def test_valid
    feed = subject.new(name: "sample")
    assert(feed.valid?)
  end

  def test_should_require_name
    feed = subject.new
    assert_not(feed.valid?)
    assert_includes(feed.errors, :name)
  end

  def test_default_refresh_interval
    feed = subject.new
    assert(feed.refresh_interval.zero?)
  end

  def test_new_feed_is_stale
    feed = subject.new
    assert(feed.stale?)
  end

  REFRESH_INTERVAL = 1.day.seconds.to_i

  def test_stale_condition
    freeze_time do
      refreshed_at = (REFRESH_INTERVAL + 1).seconds.ago

      feed = create(
        :feed,
        refresh_interval: REFRESH_INTERVAL,
        refreshed_at: refreshed_at
      )

      assert(feed.stale?)
      assert(Feed.stale.exists?(feed.id))
    end
  end

  def test_stale_condition_with_zero_refresh_interval
    freeze_time do
      feed = create(
        :feed,
        refresh_interval: 0,
        refreshed_at: Time.current
      )

      assert(feed.stale?)
      assert(Feed.stale.exists?(feed.id))
    end
  end

  def test_stale_condition_with_empty_refreshed_at
    freeze_time do
      feed = create(
        :feed,
        refresh_interval: 0,
        refreshed_at: nil
      )

      assert(feed.stale?)
      assert(Feed.stale.exists?(feed.id))
    end
  end

  def test_not_stale_condition
    freeze_time do
      feed = create(
        :feed,
        refresh_interval: REFRESH_INTERVAL,
        refreshed_at: Time.current
      )

      assert_not(feed.stale?)
      assert_not(Feed.stale.exists?(feed.id))
    end
  end

  def test_default_import_limit
    assert_nil(subject.new.import_limit)
  end
end
