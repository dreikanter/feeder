class CommitstripNormalizer < FeedjiraNormalizer
  protected

  def link
    entity.link
  end

  def attachments
    [Nokogiri::HTML(entity.content_encoded).css('img:first').first['src']]
  end

  def comments
    []
  end
end
