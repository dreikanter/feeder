require 'rss'

class AtomProcessor < BaseProcessor
  protected

  def entities
    parse_content.map { |item| Entity.new(item.link.href, item) }
  end

  def parse_content
    RSS::Parser.parse(content, false).items
  end
end
