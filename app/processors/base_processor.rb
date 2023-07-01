class BaseProcessor
  DEFAULT_IMPORT_LIMIT = 2

  def self.call(options = {})
    new(**options).call
  end

  attr_reader :content, :feed

  def initialize(content:, feed:)
    @content = content
    @feed = feed
  end

  # @return [Array<Entity>] array of entities generated from the content
  def call
    import_limit.positive? ? entities.take(import_limit) : entities
  end

  protected

  def build_entity(uid, entity_content)
    FeedEntity.new(uid: uid, content: entity_content, feed: feed)
  end

  def entities
    raise "not implemented"
  end

  private

  def import_limit
    feed.import_limit || DEFAULT_IMPORT_LIMIT
  end
end
