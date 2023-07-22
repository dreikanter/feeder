class CodingHorrorNormalizer < RssNormalizer
  def text
    [super, link].join(separator)
  end

  def attachments
    [image_url]
  end

  private

  def image_url
    Html.first_image_url(content.content_encoded)
  end
end
