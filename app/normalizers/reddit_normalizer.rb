class RedditNormalizer < BaseNormalizer
  REDDIT_HOST_PATTERN = /reddit\.com/

  def link
    xml.xpath("/entry/link").first.attributes["href"].value
  end

  def published_at
    DateTime.parse(xml.xpath("/entry/published").first.content)
  end

  def text
    source_url = extract_source_url
    source_reference = source_url.present? ? "#{separator}#{source_url}" : ""
    "#{title}#{source_reference}"
  end

  def comments
    ["Thread: #{link}"]
  end

  private

  def thumbnail_url
    xml.xpath("/entry/thumbnail").first.attributes["url"].value
  rescue StandardError
    nil
  end

  def extract_source_url
    content_urls.find { source_url?(_1) }
  end

  # NOTE: Reddit post permalinks embed the post title in the path, so they can
  #   carry non-ASCII characters. Addressable, unlike URI, parses such URLs
  #   instead of raising.
  def source_url?(url)
    host = Addressable::URI.parse(url).host
    host.present? && !host.match?(REDDIT_HOST_PATTERN)
  rescue Addressable::URI::InvalidURIError
    false
  end

  def content_urls
    parsed_content_html.css("a").map { _1.attributes["href"].value }
  end

  def parsed_content_html
    Nokogiri::HTML(xml.xpath("/entry/content").first.content)
  end

  def title
    xml.xpath("/entry/title").first.content
  end

  def xml
    @xml ||= Nokogiri::XML(content).tap { _1.remove_namespaces! }
  end
end
