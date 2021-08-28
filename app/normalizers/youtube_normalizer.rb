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
    return [] unless description?
    [description]
  end

  def description
    Html.comment_excerpt(content.content)
  end

  def description?
    options.key?('description') ? options['description'] : true
  end
end
