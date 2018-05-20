# == Schema Information
#
# Table name: feeds
#
#  id           :integer          not null, primary key
#  name         :string           not null
#  posts_count  :integer          default(0), not null
#  refreshed_at :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  url          :string
#  processor    :string
#  normalizer   :string
#  after        :datetime
#
# Indexes
#
#  index_feeds_on_name  (name) UNIQUE
#

require "test_helper"

class FeedTest < ActiveSupport::TestCase
  def feed
    @feed ||= Feed.new
  end

  def test_valid
    assert feed.valid?
  end
end
