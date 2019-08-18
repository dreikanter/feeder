class CommitstripNormalizer < RssNormalizer
  protected

  def text
    [super, link].join(separator)
  end

  def attachments
    [Nokogiri::HTML(entity.content_encoded).css('img:first').first['src']]
  end
end
