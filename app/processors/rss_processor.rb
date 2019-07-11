require 'rss'

module Processors
  class RssProcessor < Processors::Base
    protected

    def entities
      items = RSS::Parser.parse(source).try(:items)
      Rails.logger.warn('RSS has no items') unless items
      (items || []).map { |item| [item.link, item] }.to_h
    end
  end
end
