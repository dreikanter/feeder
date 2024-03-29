class BazarNormalizer < BaseNormalizer
  def link
    content.url
  end

  def published_at
    content.published
  end

  def text
    result = [content.title, link].join(separator)
    return result if record_url.blank?
    "#{result}\n\nЗапись: #{record_url} #{formatted_duration}".strip
  end

  def comments
    [Html.comment_excerpt(content.content)].compact_blank
  end

  private

  def record_url
    @record_url ||= content.try(:enclosure_url)
  end

  def formatted_duration
    return nil unless duration
    "(#{duration})"
  end

  def duration
    @duration ||= content.try(:itunes_duration).gsub(/^00:/, "")
  end
end
