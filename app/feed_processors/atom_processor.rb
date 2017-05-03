require 'rss'

module FeedProcessors
  class AtomProcessor < FeedProcessors::Base
    def entities
      items = RSS::Parser.parse(source, false).items
      Rails.logger.warn "RSS::Parser.parse().items returned nil"
      return [] unless items
      items.map { |i| [i.link.href, i] }
    end
  end
end
