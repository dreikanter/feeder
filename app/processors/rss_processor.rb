class RssProcessor < BaseProcessor
  protected

  def entities
    items = RSS::Parser.parse(content).try(:items)
    Rails.logger.warn('RSS has no items') unless items
    (items || []).map { |item| Entity.new(item.link, item) }
  end
end
