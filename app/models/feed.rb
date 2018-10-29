# == Schema Information
#
# Table name: feeds
#
#  id               :integer          not null, primary key
#  name             :string           not null
#  posts_count      :integer          default(0), not null
#  refreshed_at     :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  url              :string
#  processor        :string
#  normalizer       :string
#  after            :datetime
#  refresh_interval :integer          default(0), not null
#
# Indexes
#
#  index_feeds_on_name  (name) UNIQUE
#

class Feed < ApplicationRecord
  has_many :posts

  validates :name, presence: true
end
