class ReworkNormalizer < BaseNormalizer
  # NOTE: Sometimes RSS items don't have <content:encoded> element

  def link
    content.url
  end

  def published_at
    content.published
  end

  def text
    "#{content.title}\n#{content.enclosure_url} #{formatted_duration}".strip
  end

  def comments
    [description].compact_blank
  end

  private

  def description
    content.summary
  end

  def formatted_duration
    return nil unless duration
    seconds = Integer(duration)
    "(#{Time.at(seconds).utc.strftime("%H:%M:%S").gsub(/^(00:|0)/, "")})"
  end

  def duration
    @duration ||= content.try(:itunes_duration)
  end
end
