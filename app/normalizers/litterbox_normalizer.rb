class LitterboxNormalizer < WordpressNormalizer
  protected

  def link
    content.url
  end

  def published_at
    content.published
  end

  def text
    [content.title, link].join(separator)
  end

  def attachments
    return extract_slides if slides?
    [extract_single_image]
  end

  def comments
    [bonus_panel_comment].compact
  end

  private

  def extract_slides
    page_html.css('.swiper-wrapper img').map { |element| element['src'] }
  end

  def page_html
    @page_html ||= Nokogiri::HTML(RestClient.get(link).body)
  end

  def slides?
    page_html.css('.swiper-wrapper').present?
  end

  def extract_single_image
    Html.first_image_url(content.content)
  end

  def description
    excerpt = Html.squeeze(content.content)
    Html.comment_excerpt(excerpt)
  end

  def bonus_panel_comment
    url = bonus_panel_image_url
    "Bonus panel: #{url}" if url
  end

  def bonus_panel_image_url
    html = RestClient.get(bonus_panel_page_url).body
    Nokogiri::HTML(html).css('meta[property=og\:image]').first['content']
  rescue StandardError
    nil
  end

  def bonus_panel_page_url
    Addressable::URI.parse(link).tap do |uri|
      uri.path = uri.path.gsub(/\/+$/, '').gsub(/\/*$/, '-bonus/')
    end.to_s
  end

  def validation_errors
    super.tap do |errors|
      errors << 'bonus' if bonus?
    end
  end

  def bonus?
    link =~ /-bonus\/?$/
  end
end
