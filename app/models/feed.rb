class Feed < ApplicationRecord
  include AASM

  MAX_LIMIT_LIMIT = 100
  IMPORT_LIMIT_RANGE = 0..(86400 * 7)
  NAME_LENGTH_RANGE = 3..80
  MAX_URL_LENGTH = 4096
  MAX_DESCRIPTION_LENGTH = 256

  has_many :posts, dependent: :destroy
  has_many :error_reports, as: :target, dependent: :destroy

  # TBD: Ensure name format matches freefeed group name format
  validates :name, presence: true, length: NAME_LENGTH_RANGE, format: /\A[\w\-]+\z/
  normalizes :name, with: ->(name) { name.to_s.strip.downcase }

  validates :import_limit, numericality: {less_than_or_equal_to: MAX_LIMIT_LIMIT}
  validates :refresh_interval, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :loader, :normalizer, :processor, presence: true, format: /\A\w+\z/
  validates :url, length: {maximum: MAX_URL_LENGTH}, allow_nil: true
  validates :source_url, length: {maximum: MAX_URL_LENGTH}, allow_blank: true
  validates :description, length: {maximum: MAX_DESCRIPTION_LENGTH}, allow_blank: true
  validates :disabling_reason, length: {maximum: MAX_DESCRIPTION_LENGTH}, allow_blank: true
  validate :options_must_be_hash

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

  def configurable?
    updated_at.blank? || configured_at.blank? || updated_at.change(usec: 0) <= configured_at.change(usec: 0)
  end

  def reference
    [self.class.name.underscore, id, name].compact_blank.join("-")
  end

  def ensure_supported
    return true if loader_class && processor_class && normalizer_class
    raise FeedConfigurationError
  end

  def service_classes
    {
      loader_class: loader_class,
      processor_class: processor_class,
      normalizer_class: normalizer_class
    }
  end

  def loader_class
    ClassResolver.new(loader, suffix: "loader").resolve
  end

  def loader_instance
    loader_class.new(self)
  end

  def processor_class
    ClassResolver.new(processor, suffix: "processor").resolve
  end

  def processor_instance
    processor_class.new(self)
  end

  def normalizer_class
    ClassResolver.new(normalizer, suffix: "normalizer").resolve
  end

  private

  def options_must_be_hash
    errors.add(:options, :not_a_hash, message: "must be a hash") unless options.is_a?(Hash)
  end
end
