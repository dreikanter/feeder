class FeedjiraProcessor < BaseProcessor
  protected

  def entities
    parse_content.map { |entity| [entity.url, entity] }.to_h
  end

  def parse_content
    Feedjira::Feed.parse(content).entries
  rescue StandardError => e
    Rails.logger.error "error parsing feed: #{e}"
    []
  end
end
