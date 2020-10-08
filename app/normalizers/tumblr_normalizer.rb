class TumblrNormalizer < RssNormalizer
  protected

  def text
    [super, link].join(separator)
  end

  def attachments
    [image_url]
  end

  private

  def image_url
    Html.first_image_url(content.description)
  end
end
