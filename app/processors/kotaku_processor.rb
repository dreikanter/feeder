class KotakuProcessor < BaseProcessor
  protected

  def entities
    content.map { build_entity(_1.url, _1) }
  end
end
