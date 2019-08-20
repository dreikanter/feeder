class ReworkProcessor < BaseProcessor
  protected

  def entities
    (RSS::Parser.parse(content).try(:items) || [])
      .reject { |item| item.guid.content.blank? }
      .map { |item| Entity.new(item.guid.content, item) }
  end
end
