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

  # Attribute names, eligible to be updated from the configuration file data
  CONFIGURABLE_ATTRIBUTES = %i[
    after
    description
    disabling_reason
    import_limit
    loader
    normalizer
    options
    processor
    refresh_interval
    source
    url
  ].freeze

  has_many :posts, dependent: :delete_all
  has_one :sparkline, dependent: :delete

  validates :name, presence: true

  aasm :state do
    state :pristine, initial: true
    state :enabled
    state :paused
    state :disabled

    event :enable do
      transitions from: %i[pristine disabled], to: :enabled, guard: :touch_state_updated_at
    end

    event :pause do
      transitions from: :enabled, to: :paused
    end

    event :unpause do
      transitions from: :paused, to: :enabled
    end

    event :disable do
      transitions from: %i[pristine enabled paused], to: :disabled, guard: :touch_state_updated_at
    end
  end

  scope :ordered_by, ->(attribute, direction) { order(sanitize_sql_for_order("#{attribute} #{direction} NULLS LAST")) }

  scope :stale, lambda {
    where(refresh_interval: 0)
      .or(where(refreshed_at: nil))
      .or(where("age(now(), refreshed_at) > make_interval(secs => refresh_interval)"))
  }

  # @return [true, false] true when the feed needs a refresh
  def stale?
    refresh_interval.zero? || !refreshed_at || too_long_since_last_refresh?
  end

  def update_sparkline
    SparklineBuilder.new(self, start_date: 1.month.ago, end_date: DateTime.now).create_or_update
  end

  def sparkline_points
    sparkline&.points || []
  end

  # TODO: Consider returning an instance, initialized with self
  def loader_class
    ClassResolver.new(loader, suffix: "loader") || NullLoader
  end

  def processor_class
    ProcessorResolver.call(self)
  end

  def normalizer_class
    NormalizerResolver.call(self)
  end

  private

  def too_long_since_last_refresh?
    seconds_since_last_refresh > refresh_interval
  end

  def seconds_since_last_refresh
    (Time.now.utc.to_i - refreshed_at.to_i).abs
  end

  def touch_state_updated_at
    touch(:state_updated_at)
  end
end
