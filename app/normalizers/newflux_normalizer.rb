class NewfluxNormalizer < FeedjiraNormalizer
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

  def image_url
    image = Nokogiri::HTML(page_content).css('meta[name="twitter:image"]').first
    image[:content] if image
  rescue StandardError => e
    Honeybadger.notify(e)
    nil
  end

  def page_content
    RestClient.get(link).body
  end
end
