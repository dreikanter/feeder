require 'rss'

module Processors
  class AtomProcessor < Processors::Base
    def items
      RSS::Parser.parse(source, false).items
    end

    def link(item)
      item.link.href
    end

    def published_at(item)
      item.updated.content
    end

    def text(item)
      item.title.content
    end
  end
end
