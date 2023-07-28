class WumoNormalizer < RssNormalizer
  def text
    [super, link].join(separator)
  end

  def published_at
    DateTime.new(*link.split("/").slice(-3, 3).map(&:to_i))
  rescue StandardError
    Rails.logger.error "error parsing date from url: #{link}"
    nil
  end

  def attachments
    first_image_url ? [first_image_url] : []
  end

  def validation_errors
    super.tap do |errors|
      errors << "missing image" unless first_image_url
    end
  end

  private

  def first_image_url
    @first_image_url ||= first_image.try(:[], :src)
  end

  def first_image
    Nokogiri::HTML(content.description).css("img:first").first
  end
end
