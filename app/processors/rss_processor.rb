require 'rss'

module Processors
  class RssProcessor < Processors::Base
    def entities
      items = RSS::Parser.parse(source).try(:items)
      Rails.logger.warn("RSS has no items") unless items
      (items || []).map { |i| [i.link, i] }
    end
  end
end
