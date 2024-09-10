FactoryBot.define do
  factory :feed_content, class: "FeedContent" do
    content { "CONTENT" }
    imported_at { Time.current }
    import_duration { 0 }

    initialize_with do
      new(
        content: content,
        imported_at: imported_at,
        import_duration: import_duration
      )
    end
  end
end
