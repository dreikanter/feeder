class TestProcessor < BaseProcessor
  protected

  def entities
    JSON.parse(content).map do |entity|
      Entity.new(entity.fetch('link'), entity)
    end
  end
end
