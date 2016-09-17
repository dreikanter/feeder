require 'rss'

module FeedProcessors
  class AtomProcessor < FeedProcessors::Base
    def entities
      RSS::Parser.parse(source, false).items
    end

    def default_normalizer
      EntityNormalizers::AtomNormalizer
    end
  end
end
