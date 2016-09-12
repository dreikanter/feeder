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

require "test_helper"

class PostTest < ActiveSupport::TestCase
  def post
    @post ||= Post.new
  end

  def test_valid
    assert post.valid?
  end
end
