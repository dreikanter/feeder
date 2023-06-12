class LobstersNormalizer < FeedjiraNormalizer
  protected

  def link
    content.url
  end

  def published_at
    content.published
  end

  def text
    [content.title, content.url].join(separator)
  end

  def comments
    ["Comments: #{content.entry_id} #{tags}"]
  end

  private

  def tags
    content.categories.map { |category| "##{category}" }.join(" ")
  end
end
