class CommitstripNormalizer < FeedjiraNormalizer
  protected

  def attachments
    [Nokogiri::HTML(entity.content).css('img:first').first['src']]
  end

  def comments
    []
  end
end
