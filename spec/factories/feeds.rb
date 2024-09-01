FactoryBot.define do
  factory :feed, class: "Feed" do
    name { "sample" }
    url { "https://example.com/rss" }
    import_limit { 0 }
    refresh_interval { 0 }
    loader { "test" }
    processor { "test" }
    normalizer { "test" }
  end
end
