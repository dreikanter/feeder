# TODO: Use Feedjira processor instead

class YoutubeProcessor < BaseProcessor
  protected

  def entities
    parse_content.map { |item| Entity.new(item.url, item) }
  end

  def parse_content
    Feedjira::Feed.parse(content).entries
  rescue StandardError => e
    Rails.logger.error "error parsing feed: #{e}"
    []
  end
end
