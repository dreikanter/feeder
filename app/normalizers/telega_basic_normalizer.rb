class TelegaBasicNormalizer < RssNormalizer
  protected

  def text
    Html.post_excerpt(
      content,
      link: sanitized_link,
      separator: separator
    )
  end

  def sanitized_link
    entity.link.to_s.gsub(%r{^//}, 'https://')
  end

  def attachments
    image_url ? [image_url] : []
  end

  private

  def content
    (paragraphs[0..-1] || []).join("\n\n")
  end

  def paragraphs
    Html.paragraphs(entity.description)
  end

  def image_url
    html = Nokogiri::HTML(entity.description)
    html.css('img').first.attributes['src'].value
  rescue StandardError
    nil
  end
end
