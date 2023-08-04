class ServiceInstance < ApplicationRecord
  include AASM

  MAX_ERRORS = 3

  validates :service_type, :url, :errors_count, :total_errors_count, presence: true
  validates :url, uniqueness: {scope: :service_type}

  aasm column: :state, requires_lock: true do
    state :enabled, initial: true
    state :failed
    state :suspended
    state :disabled

    event :fail do
      after do
        update_error_counters
        suspend_if_too_many_errors
      end

      transitions from: %i[enabled failed], to: :failed
    end

    event :suspend do
      transitions from: %i[enabled failed], to: :suspended
    end

    event :enable do
      after { update!(errors_count: 0) }

      transitions from: %i[failed suspended disabled], to: :enabled
    end

    event :disable do
      transitions from: %i[enabled failed suspended], to: :disabled
    end
  end

  scope :operational, -> { where(state: %w[enabled failed]).least_used }
  scope :least_used, -> { order(arel_table[:used_at].asc.nulls_first) }

  scope :ordered_by_state, -> {
    order(Arel.sql("array_position(ARRAY['enabled', 'failed', 'suspended', 'disabled'], service_instances.state::text)"))
  }

  # @return [ServiceInstance] least used operational service instance of
  #   the specified type. Instance usage is determined by the min used_at
  #   timestamp. "Operational" means not disabled or suspended.
  def self.pick!(required_type)
    operational.where(service_type: required_type).first!
  end

  def register_error
    fail! if may_fail?
  end

  private

  def update_error_counters
    update!(
      failed_at: Time.current,
      errors_count: errors_count.succ,
      total_errors_count: total_errors_count.succ
    )
  end

  def suspend_if_too_many_errors
    return unless may_suspend?
    suspend! if errors_count >= MAX_ERRORS
  end
end
