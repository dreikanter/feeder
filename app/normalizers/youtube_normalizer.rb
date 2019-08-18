class YoutubeNormalizer < BaseNormalizer
  protected

  def link
    entity.url
  end

  def published_at
    entity.published
  end

  def text
    [entity.title, entity.url].join(separator)
  end

  def comments
    [Html.comment_excerpt(entity.content)]
  end
end
