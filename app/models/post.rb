class Post < ApplicationRecord
  include AASM

  belongs_to :feed, counter_cache: true

  aasm column: :state do
    state :draft, initial: true
    state :enqueued
    state :rejected
    state :published
    state :failed

    event :enqueue do
      transitions from: :draft, to: :enqueued
    end

    event :reject do
      transitions from: :draft, to: :rejected
    end

    event :success do
      transitions from: :enqueued, to: :published
    end

    event :fail do
      transitions from: :enqueued, to: :failed
    end
  end

  validates :uid, :published_at, presence: true

  def validation_errors?
    validation_errors.any?
  end

  def permalink
    Addressable::URI.parse(Rails.configuration.feeder.freefeed_base_url).join("/#{feed.name}/#{freefeed_post_id}").to_s
  end
end
