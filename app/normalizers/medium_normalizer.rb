class MediumNormalizer < RssNormalizer
  protected

  def text
    [super, "!#{link}"].reject(&:blank?).join(separator)
  end

  def attachments
    [image_url]
  rescue StandardError
    []
  end

  def comments
    [excerpt]
  rescue StandardError
    []
  end

  def image_url
    @image_url ||= description
      .css('.medium-feed-image img:first').first['src']
  end

  def description
    Nokogiri::HTML(content.description)
  end

  def excerpt
    result = page_body
    result.css('br').each { |br| br.replace "\n" }
    result.css('h1').each { |h1| h1.replace '' }
    Html.comment_excerpt(Html.squeeze(result.text))
  end

  def page_body
    @page_body ||= Nokogiri::HTML(page_content)
      .css('.section--body .section-content').first
  end

  def page_content
    RestClient.get(link).body
  end
end
