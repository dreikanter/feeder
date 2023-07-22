class BaseProcessor
  attr_reader :content, :feed

  def initialize(content:, feed:)
    @content = content
    @feed = feed
  end

  # @return [Array<FeedEntity>] array of entities generated from the content
  def entities
    raise AbstractMethodError
  end

  protected

  # @return [FeedEntity] creates FeedEntity instance
  def build_entity(uid, entity_content)
    FeedEntity.new(uid: uid, content: entity_content, feed: feed)
  end
end
