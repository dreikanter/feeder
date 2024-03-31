class RedditNormalizer < BaseNormalizer
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
    content_urls.reject { URI.parse(_1).host =~ /reddit\.com/ }.first
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
