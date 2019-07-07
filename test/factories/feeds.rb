FactoryBot.define do
  factory :feed, class: Feed do
    name { 'sample' }
    posts_count { 0 }
    refreshed_at { nil }
    created_at { Time.new.utc }
    updated_at { Time.new.utc }
    url { nil }
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
      name { 'sample-twitter' }
      loader { 'twitter' }
      processor { 'twitter' }
      normalizer { 'twitter' }
      options { { 'twitter_user' => 'dreikanter' } }
    end
  end
end
