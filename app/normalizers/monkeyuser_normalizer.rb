class MonkeyuserNormalizer < FeedjiraNormalizer
  protected

  def text
    [super, link].join(separator)
  end

  def attachments
    [image_url]
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
