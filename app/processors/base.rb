module Processors
  class Base
    extend Dry::Initializer

    param :source
    option :limit, default: proc { 0 }

    def self.call(source, options = {})
      new(source, options).call
    end

    def call
      (limit > 0) ? entities.take(limit) : entities
    end

    protected

    def entities
      raise NotImplementedError
    end
  end
end
