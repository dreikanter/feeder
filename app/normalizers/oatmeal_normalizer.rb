class OatmealNormalizer < RssNormalizer
  def text
    [super, "!#{link}"].join(separator)
  end

  def attachments
    [image_url]
  rescue StandardError
    []
  end

  private

  def image_url
    Nokogiri::HTML(content.description).css("img").first["src"]
  end
end
