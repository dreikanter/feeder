# TODO: Drop Processors namespace
# TODO: Rename to BaseProcessor
# TODO: Use objects instead of arrays to represent entities

module Processors
  class Base
    extend Dry::initializer

    param :source

    def self.call(source)
      new(source).call
    end

    protected

    def call
      (limit > 0) ? entities.take(limit) : entities
    end

    def limit
      ENV['MAX_ENTITIES_PER_FEED'].to_i
    end

    def entities
      fail NotImplementedError, "#{self.class.name}##{__method__} is not implemented"
    end
  end
end
