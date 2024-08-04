class ElementyNormalizer < FeedjiraNormalizer
  include HttpClient

  def comments
    [summary]
  end

  def attachments
    [cover_image]
  end

  private

  def summary
    Html.comment_excerpt(content.summary)
  end

  def cover_image
    path = cover_image_path
    Addressable::URI.join(base_url, cover_image_path).to_s if path
  end

  def cover_image_path
    post_content = http.get(content.url).to_s
    elements = Nokogiri::HTML(post_content).css(".ill_block img")
    elements.first[:src] unless elements.blank?
  end

  def base_url
    Addressable::URI.parse(feed.url).then { "#{_1.scheme}://#{_1.host}" }
  end
end
