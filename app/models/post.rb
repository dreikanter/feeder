# == Schema Information
#
# Table name: posts
#
#  id               :integer          not null, primary key
#  feed_id          :integer          not null
#  link             :string           not null
#  published_at     :datetime         not null
#  text             :string           default(""), not null
#  attachments      :string           default([]), not null, is an Array
#  comments         :string           default([]), not null, is an Array
#  freefeed_post_id :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  status           :integer          default("idle"), not null
#  uid              :string           not null
#
# Indexes
#
#  index_posts_on_feed_id  (feed_id)
#  index_posts_on_link     (link)
#  index_posts_on_status   (status)
#

class Post < ApplicationRecord
  belongs_to :feed, counter_cache: true

  enum status: Enums::PostStatus.hash

  validate :link, :presence

  # TODO: Consider moving this to configuration
  RECENT_LIMIT = 50

  scope :publishing_queue, -> { ready.order(published_at: :asc) }
  scope :publishing_queue_for, -> (feed) { publishing_queue.where(feed: feed) }
  scope :recent, -> { order(created_at: :desc).limit(RECENT_LIMIT) }

  delegate :name, :after, to: :feed, prefix: :feed

  before_save :sanitize_published_at

  def feeds
    feed ? [feed.name] : []
  end

  def stale?
    feed_after.present? && (published_at < feed_after)
  end

  private

  def sanitize_published_at
    self.published_at ||= DateTime.now
  end
end
