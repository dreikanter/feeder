class CommitstripNormalizer < FeedjiraNormalizer
  protected

  def text
    [content.title, content.url].join(separator)
  end

  def link
    content.url
  end

  def attachments
    [Nokogiri::HTML(content.content).css("img:first").first["src"]]
  end

  def comments
    []
  end
end
