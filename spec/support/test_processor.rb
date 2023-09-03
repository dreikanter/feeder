class TestProcessor < BaseProcessor
  def process
    [
      FeedEntity.new(uid: "1", content: "", feed: Feed.new),
      FeedEntity.new(uid: "2", content: "", feed: Feed.new)
    ]
  end
end
