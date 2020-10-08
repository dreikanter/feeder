class TelegaNormalizer < RssNormalizer
  protected

  def text
    Html.post_excerpt(
      paragraphs.first,
      link: sanitized_link,
      separator: separator
    )
  end

  def sanitized_link
    content.link.to_s.gsub(%r{^//}, 'https://')
  end

  def comments
    [excerpt] || []
  end

  private

  def excerpt
    Html.comment_excerpt((paragraphs[1..] || []).join("\n\n"))
  end

  def paragraphs
    @paragraphs ||= Html.paragraphs(content.description)
  end
end
