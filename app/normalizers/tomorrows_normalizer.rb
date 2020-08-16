class TomorrowsNormalizer < RssNormalizer
  protected

  def text
    [entity.title, link].join(separator)
  end

  def comments
    [entity.description].reject(&:blank?)
  end
end
