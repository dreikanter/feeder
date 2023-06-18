class HackernewsProcessor < BaseProcessor
  protected

  def entities
    sorted_items.map { |item| entity(item.fetch("id"), item) }
  end

  def sorted_items
    content.sort_by { |item| item.fetch("id") }
  end
end
