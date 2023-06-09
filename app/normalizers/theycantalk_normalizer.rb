class TheycantalkNormalizer < TumblrNormalizer
  protected

  def text
    [post_excerpt, link].compact_blank.join(separator)
  end

  def attachments
    [image_url]
  end

  def comments
    paragraphs[1..] || []
  end

  private

  def image_url
    Html.first_image_url(content.description)
  end

  def post_excerpt
    Html.post_excerpt(paragraphs.first)
  end

  def paragraphs
    @paragraphs ||= Html.paragraphs(content.description)
  end
end
