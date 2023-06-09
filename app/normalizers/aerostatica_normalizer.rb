class AerostaticaNormalizer < BaseNormalizer
  def link
    content.url
  end

  def published_at
    content.published
  end

  def text
    result = [content.title, link].join(separator)
    record_url = fetch_record_url
    return result unless record_url.present?
    "#{result}\n\nЗапись эфира: #{record_url}"
  end

  def comments
    [description].compact_blank
  end

  private

  def image_url
    Html.first_image_url(content.content)
  end

  LINE_BREAK = %r{\n+|<br\s*/?>}.freeze

  def description
    excerpt = Html.squeeze(content.content)
    Html.comment_excerpt(excerpt.to_s.gsub(LINE_BREAK, "\n\n"))
  end

  def fetch_record_url
    content = RestClient.get(link).body
    AerostaticaRecordLinkExtractor.call(content)
  rescue StandardError
    Rails.logger.error("error fetching record url from #{link}")
    nil
  end
end
