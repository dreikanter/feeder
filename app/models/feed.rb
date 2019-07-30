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

class Feed < ApplicationRecord
  has_many :posts

  validates :name, presence: true

  enum status: Enums::FeedStatus.definition

  def stale?
    return true if refresh_interval.zero? || !refreshed_at
    (Time.now.utc.to_i - refreshed_at.to_i).abs > refresh_interval
  end

  def self.stale
    where(refresh_interval: 0)
      .or(where(refreshed_at: nil))
      .or(where("#{PG_AGE} > #{PG_THRESHOLD}"))
  end

  PG_AGE = 'age(now(), refreshed_at)'.freeze
  PG_THRESHOLD = 'make_interval(secs => refresh_interval)'.freeze

  private_constant :PG_AGE, :PG_THRESHOLD
end
