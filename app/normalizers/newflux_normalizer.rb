class NewfluxNormalizer < FeedjiraNormalizer
  protected

  def comments
    [summary]
  end

  def attachments
    [image_url]
  end

  private

  def summary
    Html.comment_excerpt(entity.summary)
  end

  COVER_QUERY = 'meta[name="twitter:image"]'.freeze

  def image_url
    Nokogiri::HTML(page_content).css(COVER_QUERY).first[:content]
  rescue StandardError
    nil
  end

  def page_content
    RestClient.get(link).body
  end
end
