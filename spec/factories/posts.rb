FactoryBot.define do
  factory :post, class: "Post" do
    feed
    state { "draft" }
    link { "https://example.com/#{SecureRandom.uuid}" }
    published_at { Time.new.utc }
    text { "Sample post text" }
    attachments { [] }
    comments { [] }
    freefeed_post_id { nil }
    uid { SecureRandom.uuid }
  end
end
