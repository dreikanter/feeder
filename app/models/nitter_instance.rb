class NitterInstance < ApplicationRecord
  include AASM

  MAX_ERRORS = 3

  # Status:
  # - enabled - the instance is available and operational
  # - errored - there was an error during last request
  # - disabled - the instance is disabled due to the MAX_ERRORS sequential errors
  # - removed - the instance was removed from the public instances list
  # rubocop:disable Metrics/BlockLength
  aasm :status do
    state :enabled, initial: true
    state :errored
    state :disabled
    state :removed

    event :error do
      after do
        update!(errored_at: Time.current, errors_count: errors_count.succ)
        disable! if errors_count >= MAX_ERRORS
      end

      transitions from: %i[enabled errored], to: :errored
    end

    event :disable do
      transitions from: :errored, to: :disabled
    end

    event :enable do
      after { update!(errors_count: 0) }

      transitions to: :enabled
    end

    event :remove do
      transitions to: :removed
    end
  end
  # rubocop:enable Metrics/BlockLength

  def self.stats
    groups = NitterInstance.all.order(:status).select('status, COUNT(*) AS cnt').group(:status)
    groups.map { |group| "#{group.status}: #{group.cnt}" }.join('; ')
  end
end
