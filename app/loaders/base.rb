module Loaders
  class Base
    include Callee
    include Dry::Monads[:result]

    param :feed
    param :options, default: proc { {} }

    def call
      Success(perform)
    rescue StandardError => e
      Failure(e)
    end

    def perform
      raise NotImplementedError
    end
  end
end
