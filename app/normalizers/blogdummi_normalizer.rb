class BlogdummiNormalizer < BaseNormalizer
  protected

  def link
    entity.url
  end

  def published_at
    entity.published
  end

  def text
    [entity.title, link].join(separator)
  end

  def attachments
    [image_url]
  end

  def comments
    [description]
  end

  private

  def image_url
    Html.first_image_url(entity.content)
  end

  def description
    excerpt = Html.squeeze(entity.content)
    Html.comment_excerpt(excerpt)
  end
end
