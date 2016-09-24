require 'rss'

module FeedProcessors
  class AtomProcessor < FeedProcessors::Base
    def entities
      RSS::Parser.parse(source, false).items.map { |i| [i.link.href, i] }
    end
  end
end
