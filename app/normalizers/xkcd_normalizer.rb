class XkcdNormalizer < RssNormalizer
  protected

  def text
    [super, link].join(separator)
  end

  def attachments
    [image_url]
  end

  def comments
    alt = image['alt'].to_s
    return [] if alt.empty?
    [Html.comment_excerpt(Html.squeeze(alt))]
  end

  private

  def image_url
    fetch_og_image_url
  rescue StandardError
    feed_entry_image_url
  end

  def fetch_og_image_url
    html.css("meta[property=\"og:image\"]").first.attributes['content'].value
  end

  def html
    Nokogiri::HTML(page_content)
  end

  def page_content
    RestClient.get(link).body
  end

  def feed_entry_image_url
    image.first['src']
  end

  def image
    @image ||= Nokogiri::HTML(content.description).css('img:first').first
  end
end
