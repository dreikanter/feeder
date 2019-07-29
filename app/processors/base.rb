module Processors
  class Base
    include Callee

    param :source
    option :limit, default: proc { 0 }

    def call
      return entities.take(limit) if limit.positive?
      entities
    end

    protected

    def entities
      raise NotImplementedError
    end
  end
end
