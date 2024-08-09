class MonkeyuserNormalizer < FeedjiraNormalizer
  def attachments
    [image_url].compact_blank
  end

  def comments
    [image_title].compact_blank
  end

  private

  def image_title
    image_element[:title]
  end

  def image_url
    path = image_element[:src]
    Addressable::URI.join(base_url, path).to_s if path
  end

  def image_element
    Nokogiri::HTML(HTTP.get(link).to_s).css(".comic img").first
  end

  def validation_errors
    super.tap do |errors|
      errors << "no image" unless attachments.any?
    end
  end

  def base_url
    Addressable::URI.parse(feed.url).then { "#{_1.scheme}://#{_1.host}" }
  end
end
