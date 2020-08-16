class TomorrowsNormalizer < RssNormalizer
  protected

  def text
    [entity.title, link].join(separator)
  end

  def comments
    [excerpt].reject(&:blank?)
  end

  private

  def excerpt
    Html.comment_excerpt(Html.squeeze(content).to_s.gsub(/\n+/, "\n\n"))
  end

  def content
    Nokogiri::HTML(page_body).css('.entry-content').text
  end

  def page_body
    RestClient.get(link).body
  end
end
