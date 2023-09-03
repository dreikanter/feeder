class YoutubeProcessor < BaseProcessor
  def process
    parse_content.map { build_entity(_1.url, _1) }
  end

  private

  def parse_content
    Feedjira.parse(content).entries
  end
end
