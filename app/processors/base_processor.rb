class BaseProcessor
  include Callee
  include Dry::Monads[:result]

  param :content
  param :feed
  option :import_limit, optional: true, default: -> { nil }
  option :logger, optional: true, default: -> { Rails.logger }

  DEFAULT_LIMIT = 2

  def call
    logger.info("processing feed [#{feed_name}]")
    Success(limit.positive? ? entities.take(limit) : entities)
  rescue StandardError => e
    logger.error("error processing feed [#{feed_name}]")
    Failure(e)
  end

  protected

  def entities
    raise NotImplementedError
  end

  def limit
    import_limit || feed.import_limit || DEFAULT_LIMIT
  end

  def feed_name
    feed&.name
  end
end
