module Processors
  class Base
    include Callee
    include Dry::Monads[:result]

    param :source
    param :feed
    option :import_limit, optional: true, default: -> { nil }
    option :logger, optional: true, default: -> { Rails.logger }

    DEFAULT_LIMIT = 2

    def call
      Success(limit.positive? ? entities.take(limit) : entities)
    rescue StandardError => e
      logger.error(e)
      Failure(e)
    end

    protected

    def entities
      raise NotImplementedError
    end

    def limit
      import_limit || feed.import_limit || DEFAULT_LIMIT
    end
  end
end
