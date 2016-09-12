# == Schema Information
#
# Table name: posts
#
#  id               :integer          not null, primary key
#  feed_id          :integer          not null
#  title            :string
#  link             :string           not null
#  description      :string
#  published_at     :datetime
#  guid             :string
#  extra            :json             not null
#  freefeed_post_id :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_posts_on_feed_id  (feed_id)
#

class Post < ApplicationRecord
  belongs_to :feed, counter_cache: true
end
