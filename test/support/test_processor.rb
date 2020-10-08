class TestProcessor < BaseProcessor
  protected

  def entities
    JSON.parse(content).map { |item| entity(item.fetch('link'), item) }
  end
end
