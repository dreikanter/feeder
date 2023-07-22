class KotakuProcessor < BaseProcessor
  def entities
    content.map { build_entity(_1.url, _1) }
  end
end
