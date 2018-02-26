require 'rss'

module Processors
  class AtomProcessor < Processors::Base
    def entities
      items = RSS::Parser.parse(source, false).items
      Rails.logger.warn "RSS::Parser.parse().items returned nil"
      return [] unless items
      items.map { |i| [i.link.href, i] }
    end
  end
end
