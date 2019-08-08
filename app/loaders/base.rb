module Loaders
  class Base
    include Callee
    include Dry::Monads[:result]

    param :feed
    option :logger, optional: true, default: -> { Rails.logger }

    def call
      logger.info("loading feed [#{feed&.name}]")
      Success(perform)
    rescue StandardError => e
      logger.error("error loading feed [#{feed&.name}]")
      Failure(e)
    end

    protected

    def perform
      raise NotImplementedError
    end
  end
end
