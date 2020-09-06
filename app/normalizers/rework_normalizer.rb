class ReworkNormalizer < BaseNormalizer
  protected

  # NOTE: Sometimes RSS items don't have <content:encoded> element

  def link
    entity.url
  end

  def published_at
    entity.published
  end

  def text
    "#{entity.title}\n#{entity.enclosure_url} #{formatted_duration}".strip
  end

  def comments
    [description].reject(&:blank?)
  end

  private

  def description
    entity.summary
  end

  def formatted_duration
    return nil unless duration
    seconds = Integer(duration)
    "(#{Time.at(seconds).utc.strftime('%H:%M:%S').gsub(/^(00:|0)/, '')})"
  end

  def duration
    @duration ||= entity.try(:itunes_duration)
  end
end
