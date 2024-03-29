class FeedjiraNormalizer < BaseNormalizer
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
    [content.content]
  end
end
