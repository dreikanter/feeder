class WumoNormalizer < RssNormalizer
  protected

  def text
    [super, link].join(separator)
  end

  def published_at
    DateTime.new(*link.split('/').slice(-3, 3).map(&:to_i))
  rescue StandardError
    Rails.logger.error "error parsing date from url: #{link}"
    nil
  end

  def attachments
    [image_url]
  end

  def image_url
    Nokogiri::HTML(content.description).css('img:first').first[:src]
  end
end
