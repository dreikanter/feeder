class BuniNormalizer < FeedjiraNormalizer
  protected

  def text
    [title, entity.url].join(separator)
  end

  def attachments
    [image_url]
  end

  def comments
    [optional_webtoons_reference]
  end

  def validation_errors
    attachments.none? ? ['no images'] : super
  end

  private

  def title
    image_title = image[:alt]
    image_title.blank? ? entity.title : image_title
  end

  def image_url
    image[:src] if image
  end

  def image
    @image ||= Nokogiri::HTML(page_content).css(image_selector).first
  end

  def image_selector
    webtoons? ? '.entry img[srcset]' : '#comic img'
  end

  def page_content
    RestClient.get(link).body
  end

  def optional_webtoons_reference
    return unless webtoons? && first_url
    "Check out today's comic on Webtoons: #{first_url}"
  end

  WEBTOONS_DOMAIN = /webtoons\.com/.freeze

  def webtoons?
    @webtoons ||= URI.parse(first_url).hostname.to_s.match?(WEBTOONS_DOMAIN)
  end

  def first_url
    links.first[:href] if links.any?
  end

  def links
    @links ||= Nokogiri::HTML(entity.content).css('a')
  end
end
