class CommitstripNormalizer < FeedjiraNormalizer
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
