class TelegaBasicNormalizer < RssNormalizer
  protected

  def text
    Html.post_excerpt(
      post_content,
      link: sanitized_link,
      separator: separator
    )
  end

  def sanitized_link
    content.link.to_s.gsub(%r{^//}, "https://")
  end

  def attachments
    image_url ? [image_url] : []
  end

  private

  def post_content
    (paragraphs[0..] || []).join("\n\n")
  end

  def paragraphs
    Html.paragraphs(content.description)
  end

  def image_url
    html = Nokogiri::HTML(content.description)
    html.css("img").first.attributes["src"].value
  rescue
    nil
  end
end
