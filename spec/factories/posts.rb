FactoryBot.define do
  factory :post, class: Post do
    association :feed
    link { "https://example.com/#{SecureRandom.uuid}" }
    published_at { Time.new.utc }
    text { "Sample post text" }
    attachments { [] }
    comments { [] }
    freefeed_post_id { SecureRandom.uuid }
    status { PostStatus.published }
    uid { SecureRandom.uuid }
  end
end
