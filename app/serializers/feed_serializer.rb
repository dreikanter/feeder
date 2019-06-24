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
  attribute :refreshed_at
  attribute :created_at
  attribute :updated_at
  attribute :last_post_created_at
end
