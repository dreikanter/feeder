class SmbcNormalizer < BaseNormalizer
  protected

  def link
    content.link
  end

  def published_at
    content.pubDate
  end

  def text
    [title, link].join(separator)
  end

  def attachments
    [image_url, hidden_image_url].compact_blank
  end

  def comments
    [description].compact_blank
  end

  private

  TITLE_PREFIX = /^Saturday Morning Breakfast Cereal - /

  def title
    content.title.gsub(TITLE_PREFIX, "")
  end

  def parsed_description
    @parsed_description ||= Nokogiri::HTML(content.description)
  end

  DESCRIPTION_PREFIX = /^Hovertext:\s*/

  def description
    first_paragraph = parsed_description.css("p").first.children.text
    first_paragraph.gsub(DESCRIPTION_PREFIX, "")
  rescue StandardError
    nil
  end

  def image_url
    parsed_description.css("img").first.attributes["src"].value
  rescue StandardError
    nil
  end

  def hidden_image_url
    html = Nokogiri::HTML(page_content)
    html.css("#aftercomic img").first.attributes["src"].value
  rescue StandardError
    nil
  end

  def page_content
    RestClient.get(link).body
  end
end
