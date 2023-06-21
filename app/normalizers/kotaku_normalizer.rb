class KotakuNormalizer < BaseNormalizer
  protected

  def text
    "#{content.title.strip} by #{content.author.strip} - #{content.url}"
  end

  def link
    content.url
  end

  def published_at
    content.published
  end

  def attachments
    [content.image].compact_blank
  end

  def comments
    [summary].compact_blank
  end

  def summary
    Html.comment_excerpt(content.summary).gsub(/Read more\.\.\./, "").strip
  end
end
