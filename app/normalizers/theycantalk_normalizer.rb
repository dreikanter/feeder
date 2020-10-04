class TheycantalkNormalizer < TumblrNormalizer
  protected

  def text
    [post_excerpt, link].reject(&:blank?).join(separator)
  end

  def attachments
    [image_url]
  end

  def comments
    paragraphs[1..] || []
  end

  private

  def image_url
    Html.first_image_url(entity.description)
  end

  def post_excerpt
    Html.post_excerpt(paragraphs.first)
  end

  def paragraphs
    @paragraphs ||= Html.paragraphs(entity.description)
  end
end
