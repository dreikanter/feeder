require 'rss'

module FeedProcessors
  class RssProcessor < FeedProcessors::Base
    def entities
      RSS::Parser.parse(source).items.map { |i| [i.link, i] }
    end
  end
end
