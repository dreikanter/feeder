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
#
# Indexes
#
#  index_feeds_on_name  (name) UNIQUE
#

class Feed < ApplicationRecord
  has_many :posts

  validates :name, presence: true

  def refresh?
    return true if refresh_interval.zero? || !refreshed_at
    (Time.now.utc.to_i - refreshed_at.to_i).abs > refresh_interval
  end

  RECENT_PERIOD_IN_DAYS = 30
  DAYS_IN_A_WEEK = 7

  def avg_posts_per_week
    recent_posts.count.to_f / RECENT_PERIOD_IN_DAYS * DAYS_IN_A_WEEK
  end

  private

  def recent_posts
    posts.published.where('published_at > ?', RECENT_PERIOD_IN_DAYS.days.ago)
  end
end
