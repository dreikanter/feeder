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

  attribute :feed_name do
    object.feed.name
  end

  attribute :freefeed_url do
    Service::FreefeedPostURL.call(object.feed.name, object.freefeed_post_id)
  end
end
