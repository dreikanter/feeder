class BazarNormalizer < BaseNormalizer
  protected

  def link
    entity.url
  end

  def published_at
    entity.published
  end

  def text
    result = [entity.title, link].join(separator)
    return result unless record_url.present?
    "#{result}\n\nЗапись: #{record_url} #{formatted_duration}".strip
  end

  def comments
    [entity.content].reject(&:blank?)
  end

  private

  def record_url
    @record_url ||= entity.try(:enclosure_url)
  end

  def formatted_duration
    return nil unless duration
    "(#{duration})"
  end

  def duration
    @duration ||= entity.try(:itunes_duration).gsub(/^00:/, '')
  end
end
