class BaseProcessor
  include Callee

  param :content
  option :feed
  option :import_limit, optional: true, default: -> {}
  option :logger, optional: true, default: -> { Rails.logger }

  DEFAULT_LIMIT = 2

  def call
    logger.info("---> processing [#{feed.name}] with [#{self.class.name}]")
    actual_entities
  end

  protected

  def actual_entities
    return entities.take(limit) if limit.positive?
    entities
  end

  def entity(uid, entity_content)
    Entity.new(uid: uid, content: entity_content, feed: feed)
  end

  def entities
    raise "not implemented"
  end

  def limit
    import_limit || feed.import_limit || DEFAULT_LIMIT
  end

  def feed_name
    feed&.name
  end
end
