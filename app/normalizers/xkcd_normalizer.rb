class XkcdNormalizer < RssNormalizer
  protected

  def text
    [super, link].join(separator)
  end

  def attachments
    [image['src']]
  end

  def comments
    alt = image['alt'].to_s
    return [] if alt.empty?
    [Html.comment_excerpt(Html.squeeze(alt))]
  end

  def image
    @image ||= Nokogiri::HTML(entity.description).css('img:first').first
  end
end
