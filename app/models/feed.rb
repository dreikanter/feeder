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
  include AASM

  has_many :posts

  validates :name, presence: true

  # TODO: Replace with #state
  enum status: FeedStatus.options

  aasm :state do
    state :enabled, initial: true
    state :disabled
    state :removed

    event :disable do
      transitions from: :enabled, to: :disabled
    end

    event :enable do
      transitions from: %i[disabled removed], to: :enabled
    end

    event :remove do
      transitions to: :removed
    end
  end

  scope :ordered_active, -> { active.order(FEEDS_ORDER) }

  def stale?
    return true if refresh_interval.zero? || !refreshed_at
    (Time.now.utc.to_i - refreshed_at.to_i).abs > refresh_interval
  end

  # TODO: Replace with a scope
  def self.stale
    where(refresh_interval: 0)
      .or(where(refreshed_at: nil))
      .or(where("#{PG_AGE} > #{PG_THRESHOLD}"))
  end

  PG_AGE = 'age(now(), refreshed_at)'.freeze
  PG_THRESHOLD = 'make_interval(secs => refresh_interval)'.freeze
  ORDER_FIELD = 'last_post_created_at'.freeze
  FEEDS_ORDER = Arel.sql("#{ORDER_FIELD} IS NULL, #{ORDER_FIELD} DESC")

  private_constant :ORDER_FIELD, :FEEDS_ORDER, :PG_AGE, :PG_THRESHOLD
end
