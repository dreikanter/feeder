class KimchicuddlesNormalizer < BaseNormalizer
  protected

  def text
    entity.url
  end

  def link
    entity.url
  end

  def published_at
    entity.published
  end

  def attachments
    [TumblrImageFetcher.call(image_url)]
  end

  def comments
    [description]
  end

  private

  def image_url
    Html.first_image_url(entity.summary)
  end

  def description
    result = Html.comment_excerpt(entity.summary)
    result.to_s.gsub(/\n+/, "\n")
  end
end
