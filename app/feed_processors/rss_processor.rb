require 'rss'

module FeedProcessors
  class RssProcessor < FeedProcessors::Base
    def entities
      items = RSS::Parser.parse(source).items
      Rails.logger.warn "RSS::Parser.parse().items returned nil"
      return [] unless items
      items.map { |i| [i.link, i] }
    end
  end
end
