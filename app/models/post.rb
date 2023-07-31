# == Schema Information
#
# Table name: posts
#
#  id                :integer          not null, primary key
#  feed_id           :integer          not null
#  link              :string           not null
#  published_at      :datetime         not null
#  text              :string           default(""), not null
#  attachments       :string           default([]), not null, is an Array
#  comments          :string           default([]), not null, is an Array
#  freefeed_post_id  :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  status            :integer          default("idle"), not null
#  uid               :string           not null
#  validation_errors :string           default([]), not null, is an Array
#
# Indexes
#
#  index_posts_on_feed_id  (feed_id)
#  index_posts_on_link     (link)
#  index_posts_on_status   (status)
#

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
  validates :link, presence: {allow_blank: true}

  def validation_errors?
    validation_errors.any?
  end

  def permalink
    base_url.join("/#{feed.name}/#{freefeed_post_id}").to_s
  end

  private

  def base_url
    Addressable::URI.parse(FreefeedClientBuilder.base_url)
  end
end
