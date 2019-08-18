# TODO: Get rid of explicit require
require 'rss'

class RssProcessor < BaseProcessor
  protected

  def entities
    items = RSS::Parser.parse(source).try(:items)
    Rails.logger.warn('RSS has no items') unless items
    (items || []).map { |item| [item.link, item] }.to_h
  end
end
