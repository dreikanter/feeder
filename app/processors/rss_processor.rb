class RssProcessor < BaseProcessor
  protected

  def entities
    items = RSS::Parser.parse(content).try(:items)
    (items || []).map { build_entity(_1.link, _1) }
  end
end
