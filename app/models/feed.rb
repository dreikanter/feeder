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
#
# Indexes
#
#  index_feeds_on_name  (name) UNIQUE
#

class Feed < ApplicationRecord
  has_many :posts

  def self.find_or_import(name)
    Feed.find_by_name(name) || Feed.create(Service::Feeds.find(name).to_h)
  end
end
