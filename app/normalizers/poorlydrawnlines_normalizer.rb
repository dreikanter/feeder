class PoorlydrawnlinesNormalizer < BaseNormalizer
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

  private

  def image_url
    Html.first_image_url(entity.content)
  end
end
