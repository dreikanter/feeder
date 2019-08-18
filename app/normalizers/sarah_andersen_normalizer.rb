class SarahAndersenNormalizer < TumblrNormalizer
  protected

  def text
    [post_excerpt, link].reject(&:blank?).join(separator)
  end

  def attachments
    [image_url]
  end

  private

  def image_url
    Html.first_image_url(entity.description)
  end

  def post_excerpt
    Html.post_excerpt(entity.description)
  end
end
