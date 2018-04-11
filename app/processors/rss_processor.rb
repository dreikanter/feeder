require 'rss'

module Processors
  class RssProcessor < Processors::Base
    def entities
      Rails.logger.warn "RSS::Parser.parse().items returned nil"
      return [] unless items
      items.map { |i| [i.link, i] }
      items = RSS::Parser.parse(source).try(:items)
    end
  end
end
