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

class PostSerializer < ApplicationSerializer
  attribute :id
  attribute :feed_id
  attribute :link
  attribute :text
  attribute :attachments
  attribute :comments
  attribute :freefeed_post_id
  attribute :created_at
  attribute :updated_at
  attribute :published_at
  attribute :status
end
