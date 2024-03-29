class YoutubeNormalizer < BaseNormalizer
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

  private

  def description
    Html.comment_excerpt(content.content)
  end

  def description?
    feed_options.key?("description") ? feed_options["description"] : false
  end
end
