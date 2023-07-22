class PoorlydrawnlinesNormalizer < BaseNormalizer
  def link
    content.url
  end

  def published_at
    content.published
  end

  def text
    [content.title, link].join(separator)
  end

  def attachments
    [image_url]
  end

  private

  def image_url
    Html.first_image_url(content.content)
  end
end
