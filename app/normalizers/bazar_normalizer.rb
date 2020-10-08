class BazarNormalizer < BaseNormalizer
  protected

  def link
    content.url
  end

  def published_at
    content.published
  end

  def text
    result = [content.title, link].join(separator)
    return result unless record_url.present?
    "#{result}\n\nЗапись: #{record_url} #{formatted_duration}".strip
  end

  def comments
    [content.content].reject(&:blank?)
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
    @duration ||= content.try(:itunes_duration).gsub(/^00:/, '')
  end
end
