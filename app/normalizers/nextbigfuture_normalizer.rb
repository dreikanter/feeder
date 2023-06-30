class NextbigfutureNormalizer < BaseNormalizer
  protected

  def link
    content.url
  end

  def published_at
    content.published
  end

  def text
    [content.title, link].join(separator)
  end

  def attachments
    [image_url].compact
  end

  def comments
    [description].compact
  end

  private

  def image_url
    @image_url ||= NextbigfutureThumbnailFetcher.call(content.url)
  end

  def description
    Html.comment_excerpt(content.summary)
  end
end
