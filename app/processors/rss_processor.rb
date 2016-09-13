require 'rss'

module Processors
  class RssProcessor < Processors::Base
    def items
      RSS::Parser.parse(source).items
    end

    def link(item)
      item.link
    end

    def published_at(item)
      item.pubDate
    end

    def text(item)
      item.title
    end
  end
end
