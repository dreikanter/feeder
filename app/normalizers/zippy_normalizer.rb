class ZippyNormalizer < FeedjiraNormalizer
  def attachments
    [image_url]
  end

  private

  def image_url
    html.css("img:first").first["src"]
  end

  def html
    Nokogiri::HTML(content.summary)
  end
end
