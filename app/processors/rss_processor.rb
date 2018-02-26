require 'rss'

module Processors
  class RssProcessor < Processors::Base
    def entities
      items = RSS::Parser.parse(source).items
      Rails.logger.warn "RSS::Parser.parse().items returned nil"
      return [] unless items
      items.map { |i| [i.link, i] }
    end
  end
end
