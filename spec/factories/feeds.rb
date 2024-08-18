FactoryBot.define do
  factory :feed, class: "Feed" do
    name { "sample" }
    url { "https://example.com/rss" }
  end
end
