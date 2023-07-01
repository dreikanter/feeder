class TestProcessor < BaseProcessor
  protected

  def entities
    JSON.parse(content).map { build_entity(_1.fetch("link"), _1) }
  end
end
