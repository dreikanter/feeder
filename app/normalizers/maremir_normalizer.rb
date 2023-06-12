class MaremirNormalizer < RssNormalizer
  WORDPRESS_THUMBNAIL_SUFFIX = "-150x150.".freeze

  protected

  def text
    [super, description, link].join(separator)
  end

  def attachments
    [first_image_url]
  end

  private

  def first_image_url
    url = Html.first_image_url(safe_content)
    url.to_s.gsub(WORDPRESS_THUMBNAIL_SUFFIX, ".")
  end

  def safe_content
    content.content_encoded || ""
  end

  def description
    Html.comment_excerpt(entity.content.description)
  end
end
