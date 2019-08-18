class PhdcomicsNormalizer < RssNormalizer
  protected

  def text
    [super, link].join(separator)
  end

  def attachments
    [Nokogiri::HTML(entity.description).css('img').first['src']]
  end
end
