class NichtlustigDeNormalizer < RssNormalizer
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
    Nokogiri::HTML(content.description).css("img")[1]["src"]
  end
end
