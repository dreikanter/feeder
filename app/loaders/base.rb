module Loaders
  class Base
    include Callee
    include Dry::Monads[:result]

    param :feed
    option :logger, optional: true, default: -> { Rails.logger }

    def call
      logger.info("loading feed [#{feed&.name}] with [#{self.class.name}]")
      Success(perform)
    rescue StandardError => e
      Failure(e)
    end

    protected

    def perform
      raise NotImplementedError
    end
  end
end
