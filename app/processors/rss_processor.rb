require 'rss'

module Processors
  class RssProcessor < Processors::Base
    def process
      items.map { |item| attrs(preprocess(item)) }
    end

    def items
      RSS::Parser.parse(source).items
    end

    ATTRS = %i(title link description published_at guid extra).freeze

    def attrs(item)
      ATTRS.map { |a| [a, send(a, item)] }.to_h
    end

    def preprocess(item)
      item
    end

    def title(item)
      item.title
    end

    def link(item)
      item.link
    end

    def description(item)
      item.description
    end

    def published_at(item)
      item.pubDate
    end

    def guid(item)
      item.guid ? item.guid.content : nil
    end

    def extra(item)
      {}
    end
  end
end
