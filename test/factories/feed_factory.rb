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
#  status               :integer          default("inactive"), not null
#
# Indexes
#
#  index_feeds_on_name    (name) UNIQUE
#  index_feeds_on_status  (status)
#

FactoryBot.define do
  factory :feed, class: Feed do
    name { SecureRandom.uuid }
    posts_count { 0 }
    refreshed_at { nil }
    created_at { Time.new.utc }
    updated_at { Time.new.utc }
    url { "https://example.com" }
    processor { nil }
    normalizer { nil }
    after { nil }
    refresh_interval { 0 }
    options { {} }
    loader { nil }
    import_limit { nil }
    last_post_created_at { nil }
    subscriptions_count { 0 }

    trait :twitter do
      name { "sample-twitter" }
      loader { "twitter" }
      processor { "twitter" }
      normalizer { "twitter" }
      options { {"twitter_user" => "dreikanter"} }
    end

    trait :kotaku do
      url { "https://kotaku.com/rss" }
      loader { "kotaku" }
      processor { "kotaku" }
      normalizer { "kotaku" }
      source { "https://kotaku.com" }
      refresh_interval { 86400 }
      import_limit { 2 }
    end

    trait :kotaku_daily do
      url { "https://kotaku.com/rss" }
      loader { "http" }
      processor { "kotaku_daily" }
      normalizer { "kotaku_daily" }
      source { "https://kotaku.com" }
      refresh_interval { 86400 }
      import_limit { 1 }
    end
  end
end
