class CommitstripNormalizer < FeedjiraNormalizer
  protected

  def link
    entity.url
  end

  def attachments
    [Nokogiri::HTML(entity.content).css('img:first').first['src']]
  end

  def comments
    []
  end
end
