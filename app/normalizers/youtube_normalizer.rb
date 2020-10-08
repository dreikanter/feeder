class YoutubeNormalizer < BaseNormalizer
  protected

  def link
    content.url
  end

  def published_at
    content.published
  end

  def text
    [content.title, content.url].join(separator)
  end

  def comments
    [Html.comment_excerpt(content.content)]
  end
end
