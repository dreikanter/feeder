class PhdcomicsNormalizer < RssNormalizer
  protected

  def text
    [super, link].join(separator)
  end

  def attachments
    [Nokogiri::HTML(content.description).css('img').first['src']]
  end
end
