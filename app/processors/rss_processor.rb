class RssProcessor < BaseProcessor
  protected

  def entities
    items = RSS::Parser.parse(content).try(:items)
    logger.warn("RSS has no items") unless items
    (items || []).map { |item| entity(item.link, item) }
  end
end
