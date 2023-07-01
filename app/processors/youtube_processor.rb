class YoutubeProcessor < BaseProcessor
  protected

  def entities
    parse_content.map { build_entity(_1.url, _1) }
  end

  def parse_content
    Feedjira.parse(content).entries
  end
end
