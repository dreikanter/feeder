require 'rss'

module FeedProcessors
  class RssProcessor < FeedProcessors::Base
    def entities
      RSS::Parser.parse(source).items
    end

    def default_normalizer
      EntityNormalizers::RssNormalizer
    end
  end
end
