class MonkeyuserNormalizer < FeedjiraNormalizer
  protected

  def text
    [super, link].join(separator)
  end

  def attachments
    [image_url]
  end

  def comments
    [image_title]
  end

  def image_title
    first_image['title']
  end

  def first_image
    @first_image ||= Nokogiri::HTML(content.summary).css('img:first').first
  end

  def image_url
    Html.first_image_url(content.summary)
  end

  def validation_errors
    super.tap do |errors|
      errors << 'no image' unless attachments.any?
    end
  end
end
