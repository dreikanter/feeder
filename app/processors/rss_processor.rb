require "rss"
require "rexml/document"

class RssProcessor < BaseProcessor
  def process
    # TBD
    REXML::Security.entity_expansion_text_limit = 10_000_000

    items = RSS::Parser.parse(content).try(:items)
    (items || []).map { build_entity(_1.link, _1) }
  end
end
