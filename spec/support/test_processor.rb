class TestProcessor < BaseProcessor
  def entities
    [
      Entity.new(uid: '1', content: '', feed: Feed.new),
      Entity.new(uid: '2', content: '', feed: Feed.new)
    ]
  end
end
