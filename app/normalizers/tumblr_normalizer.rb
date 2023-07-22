class TumblrNormalizer < RssNormalizer
  def text
    [super, link].compact.join(separator)
  end

  def attachments
    [image_url]
  end

  private

  def image_url
    Html.first_image_url(content.description)
  end
end
