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
    [image_url]
  end

  def comments
    [bonus_panel_comment].compact
  end

  private

  def image_url
    Html.first_image_url(content.content)
  end

  def description
    excerpt = Html.squeeze(content.content)
    Html.comment_excerpt(excerpt)
  end

  def bonus_panel_comment
    url = bonus_panel_image_url
    raise 'bonus panel url not found' unless url
    "Bonus panel: #{url}" if url
  end

  def bonus_panel_image_url
    html = RestClient.get(bonus_panel_page_url).body
    Nokogiri::HTML(html).css('link[rel=image_src]').first['href']
  end

  def bonus_panel_page_url
    Nokogiri::HTML(content.summary).css('a').first['href']
  end
end
