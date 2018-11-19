# TODO: Drop Processors namespace
# TODO: Rename to BaseProcessor
# TODO: Use objects instead of arrays to represent entities

module Processors
  class Base
    extend Dry::Initializer

    param :source

    def self.call(source)
      new(source).call
    end

    def call
      (limit > 0) ? entities.take(limit) : entities
    end

    protected

    def limit
      ENV['MAX_ENTITIES_PER_FEED'].to_i
    end

    def entities
      raise NotImplementedError
    end
  end
end
