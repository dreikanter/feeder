module FeedProcessors
  class Base
    def self.process(source)
      send(:new, source).send(:entities)
    end

    attr_reader :source
    attr_reader :feed_name

    private

    def initialize(source)
      @source = source
    end

    def entities
      fail NotImplementedError, "#{self.class.name}##{__method__} is not implemented"
    end
  end
end
