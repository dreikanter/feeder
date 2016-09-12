module Processors
  class Base
    def self.process(source)
      send(:new, source).send(:process)
    end

    attr_reader :source

    private

    def initialize(source)
      @source = source
    end

    def process
      fail NotImplementedError, "#{self.class.name} is not implemented"
    end
  end
end
