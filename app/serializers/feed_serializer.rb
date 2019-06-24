# == Schema Information
#
# Table name: feeds
#
#  id                   :integer          not null, primary key
#  name                 :string           not null
#  posts_count          :integer          default(0), not null
#  refreshed_at         :datetime
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  url                  :string
#  processor            :string
#  normalizer           :string
#  after                :datetime
#  refresh_interval     :integer          default(0), not null
#  options              :json             not null
#  loader               :string
#  import_limit         :integer
#  last_post_created_at :datetime
#  subscriptions_count  :integer          default(0), not null
#
# Indexes
#
#  index_feeds_on_name  (name) UNIQUE
#

class FeedSerializer < ApplicationSerializer
  attribute :id
  attribute :name
  attribute :url
  attribute :loader
  attribute :processor
  attribute :normalizer
  attribute :after
  attribute :refresh_interval
  attribute :import_limit
  attribute :posts_count
  attribute :subscriptions_count
  attribute :refreshed_at
  attribute :created_at
  attribute :updated_at
  attribute :last_post_created_at
end
