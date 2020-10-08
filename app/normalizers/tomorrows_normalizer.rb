class TomorrowsNormalizer < RssNormalizer
  protected

  def text
    [content.title, link].join(separator)
  end

  def comments
    [excerpt].reject(&:blank?)
  end

  private

  def excerpt
    Html.comment_excerpt(Html.squeeze(page_content).to_s.gsub(/\n+/, "\n\n"))
  end

  def page_content
    Nokogiri::HTML(page_body).css('.entry-content').text
  end

  def page_body
    RestClient.get(link).body
  end
end
