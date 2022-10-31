class ZippyNormalizer < FeedjiraNormalizer
  protected

  def attachments
    [image_url]
  end

  private

  def image_url
    image['src']
  end

  def image
    @image ||= html.css('img:first').first
  end

  def html
    Nokogiri::HTML(content.summary)
  end
end
