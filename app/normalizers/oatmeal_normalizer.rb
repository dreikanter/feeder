class OatmealNormalizer < RssNormalizer
  protected

  def text
    [super, "!#{link}"].join(separator)
  end

  def attachments
    [image_url]
  rescue
    []
  end

  def image_url
    Nokogiri::HTML(content.description).css("img").first["src"]
  end
end
