# == Schema Information
#
# Table name: feeds
#
#  id               :integer          not null, primary key
#  name             :string           not null
#  posts_count      :integer          default(0), not null
#  refreshed_at     :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  url              :string
#  processor        :string
#  normalizer       :string
#  after            :datetime
#  refresh_interval :integer          default(0), not null
#
# Indexes
#
#  index_feeds_on_name  (name) UNIQUE
#

require "test_helper"

class FeedTest < Minitest::Test
  def test_valid
    feed = Feed.new(name: 'sample')
    assert(feed.valid?)
  end

  def test_should_require_name
    feed = Feed.new
    refute(feed.valid?)
    assert_includes(feed.errors, :name)
  end

  def test_default_refresh_interval
    feed = Feed.new
    assert(feed.refresh_interval.zero?)
  end

  def test_always_refresh_by_default
    feed = Feed.new
    assert(feed.refresh?)
  end

  def test_should_refresh
    options = { refresh_interval: 600, refreshed_at: 700.seconds.ago }
    feed = Feed.new(options)
    assert(feed.refresh?)
  end

  def test_should_not_refresh
    options = { refresh_interval: 600, refreshed_at: 500.seconds.ago }
    feed = Feed.new(options)
    refute(feed.refresh?)
  end
end
