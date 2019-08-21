class NextbigfutureNormalizer < BaseNormalizer
  option(
    :thumb_fetcher,
    optional: true,
    default: -> { NextbigfutureThumbnailFetcher }
  )

  protected

  def link
    entity.url
  end

  def published_at
    entity.published
  end

  def text
    [entity.title, link].join(separator)
  end

  def attachments
    [image_url].compact
  end

  def comments
    [description].compact
  end

  private

  def image_url
    @image_url ||= thumb_fetcher.call(entity.url)
  end

  def description
    Html.comment_excerpt(entity.summary)
  end
end
