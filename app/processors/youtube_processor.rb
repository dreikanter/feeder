class YoutubeProcessor < BaseProcessor
  protected

  def entities
    parse_content.map { |item| entity(item.url, item) }
  end

  def parse_content
    Feedjira.parse(content).entries
  end
end
