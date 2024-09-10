FactoryBot.define do
  factory :feed_content, class: "FeedContent" do
    content { "CONTENT" }
    imported_at { Time.current }
    import_duration { 0 }
  end
end
