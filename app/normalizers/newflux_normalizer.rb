class NewfluxNormalizer < FeedjiraNormalizer
  class FetchError < StandardError; end

  protected

  def comments
    [summary]
  end

  def attachments
    [image_url]
  end

  private

  def summary
    Html.comment_excerpt(content.summary)
  end

  COVER_QUERY = 'meta[name="twitter:image"]'.freeze

  def image_url
    image = Nokogiri::HTML(page_content).css(COVER_QUERY).first
    image[:content] if image
  rescue StandardError => e
    Honeybadger.notify(e)
    nil
  end

  def page_content
    RestClient.get(link).body
  rescue StandardError
    raise FetchError, link
  end
end
