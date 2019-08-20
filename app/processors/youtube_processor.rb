class YoutubeProcessor < BaseProcessor
  protected

  def entities
    parse_content.map { |item| Entity.new(item.url, item) }
  end

  def parse_content
    Feedjira::Feed.parse(content).entries
  end
end
