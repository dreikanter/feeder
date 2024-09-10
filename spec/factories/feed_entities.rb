FactoryBot.define do
  factory :feed_entity, class: "FeedEntity" do
    feed
    uid { "https://example.com/1" }
    content { "CONTENT" }

    initialize_with do
      new(
        feed: feed,
        uid: uid,
        content: content
      )
    end
  end
end
