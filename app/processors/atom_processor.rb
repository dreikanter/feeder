require "rss"

class AtomProcessor < BaseProcessor
  protected

  def entities
    parse_content.map { build_entity(_1.link.href, _1) }
  end

  def parse_content
    RSS::Parser.parse(content, false)&.items || []
  end
end
