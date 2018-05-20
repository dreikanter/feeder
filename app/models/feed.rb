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

class Feed < ApplicationRecord
  has_many :posts

  def self.for(name)
    feed_info = Service::Feeds.find(name)
    raise 'unknown feed' unless feed_info
    feed = Feed.find_by_name(name) || Feed.create(name: name)
    feed.update(Service::Feeds.find(name).to_h)
    feed
  end
end
