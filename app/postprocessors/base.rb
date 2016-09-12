module Postprocessors
  class Base
    def self.process(entity)
      send(:new).send(:process, entity)
    end

    attr_reader :entity

    private

    def process(entity)
      fail NotImplementedError, "#{self.class.name} is not implemented"
    end
  end
end
