class FeedjiraProcessor < BaseProcessor
  protected

  def entities
    parse_content.map { |entity| Entity.new(entity.url, entity) }
  end

  def parse_content
    Feedjira::Feed.parse(content).entries
  end
end
