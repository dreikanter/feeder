module FeedProcessors
  class Base
    def self.process(source, normalizer = nil)
      send(:new, source, normalizer).send(:process)
    end

    attr_reader :source
    attr_reader :feed_name

    private

    def initialize(source, normalizer)
      @normalizer = normalizer
      @source = source
    end

    def process
      entities.map { |e| normalize e }
    end

    def entities
      fail NotImplementedError, "#{self.class.name}##{__method__} is not implemented"
    end

    def normalize(entity)
      normalizer.process(entity)
    end

    def normalizer
      @normalizer || default_normalizer
    end

    def default_normalizer
      EntityNormalizers::Base
    end
  end
end
