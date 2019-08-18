# TODO: Use Feedjira processor instead

class YoutubeProcessor < BaseProcessor
  protected

  def entities
    parse_source.map { |entity| [entity.url, entity] }.to_h
  end

  def parse_source
    Feedjira::Feed.parse(source).entries
  rescue StandardError => e
    Rails.logger.error "error parsing feed: #{e}"
    []
  end
end
