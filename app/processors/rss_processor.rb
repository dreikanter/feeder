class RssProcessor < BaseProcessor
  protected

  def entities
    items = RSS::Parser.parse(content).try(:items)
    (items || []).map { |item| entity(item.link, item) }
  end
end
