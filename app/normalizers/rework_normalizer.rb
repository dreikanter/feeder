class ReworkNormalizer < BaseNormalizer
  protected

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
    html = Nokogiri::HTML(entity.content)
    result = html.css('p').try(:first)
    result.css('br').each { |br| br.replace("\n") }
    result = result.text.squeeze(' ').gsub(/[ \n]{2,}/, "\n\n").strip
    Html.comment_excerpt(result)
  end

  def formatted_duration
    return nil unless duration
    "(#{duration})"
  end

  def duration
    @duration ||= entity.try(:itunes_duration)
  end
end
