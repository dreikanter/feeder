class KotakuNormalizer < BaseNormalizer
  protected

  def text
    "#{content.title.strip} by #{content.author.strip} - #{content.url}"
  end

  def link
    content.url
  end

  def published_at
    content.published
  end

  def attachments
    [content.image].reject(&:blank?)
  end

  def comments
    [summary].reject(&:blank?)
  end

  def summary
    Html.text(content.summary)
  end

  def validation_errors
    ["experimental"]
  end
end
