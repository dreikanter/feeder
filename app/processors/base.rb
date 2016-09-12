module Processors
  class Base
    def self.parse(source)
      send(:new, source).parse
    end

    attr_reader :source

    def parse
      fail NotImplementedError, "#{self.class.name} is not implemented"
    end

    private

    def initialize(source)
      @source = source
    end
  end
end
