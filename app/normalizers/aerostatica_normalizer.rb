class AerostaticaNormalizer < BaseNormalizer
  def link
    entity.url
  end

  def published_at
    entity.published
  end

  def text
    result = [entity.title, link].join(separator)
    record_url = fetch_record_url
    return result unless record_url.present?
    "#{result}\n\nЗапись эфира: #{record_url}"
  end

  def comments
    [description].reject(&:blank?)
  end

  private

  def image_url
    Html.first_image_url(entity.content)
  end

  LINE_BREAK = %r{\n+|\<br\s*/?\>}.freeze

  def description
    excerpt = Html.squeeze(entity.content)
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
