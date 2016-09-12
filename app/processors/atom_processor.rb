require 'rss'

module Processors
  class AtomProcessor < Processors::Base
    def process
      items.map { |item| attrs(preprocess(item)) }
    end

    def items
      RSS::Parser.parse(source, false).items
    end

    ATTRS = %i(title link description published_at guid extra).freeze

    def attrs(item)
      ATTRS.map { |a| [a, send(a, item)] }.to_h
    end

    def preprocess(item)
      item
    end

    def title(item)
      item.title.content
    end

    def link(item)
      item.link.href
    end

    def description(item)
      ''
    end

    def published_at(item)
      item.updated.content
    end

    def guid(item)
      nil
    end

    def extra(item)
      {}
    end
  end
end
