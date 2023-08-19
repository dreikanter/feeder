class MonkeyuserNormalizer < FeedjiraNormalizer
  def attachments
    [image_url].compact
  end

  def comments
    [image_title].compact
  end

  private

  def image_title
    first_image["title"] if first_image
  end

  def first_image
    @first_image ||= Nokogiri::HTML(content.summary).css("img:first").first
  end

  def image_url
    first_image["src"] if first_image
  end

  def validation_errors
    super.tap do |errors|
      errors << "no image" unless attachments.any?
    end
  end
end
