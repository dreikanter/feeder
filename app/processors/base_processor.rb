class BaseProcessor
  include Callee

  param :content
  param :feed
  option :import_limit, optional: true, default: -> { nil }
  option :logger, optional: true, default: -> { Rails.logger }

  DEFAULT_LIMIT = 2

  def call
    log("processing #{feed.name} with #{self.class.name}")
    return entities.take(limit) if limit.positive?
    entities
  end

  protected

  def entities
    raise 'not implemented'
  end

  def limit
    import_limit || feed.import_limit || DEFAULT_LIMIT
  end

  # TODO: Move to a mixin
  def log(message, level: :info)
    logger.public_send(level, "[feed:#{feed_name}] #{message}")
  end

  def feed_name
    feed&.name
  end
end
