class KimchicuddlesNormalizer < BaseNormalizer
  option(
    :image_fetcher,
    optional: true,
    default: -> { TumblrImageFetcher }
  )

  protected

  def text
    content.url
  end

  def link
    content.url
  end

  def published_at
    content.published
  end

  def attachments
    [image_url]
  end

  def comments
    [description]
  end

  private

  def image_url
    image_fetcher.call(post_url)
  end

  def post_url
    Html.first_image_url(content.summary)
  end

  def description
    result = Html.comment_excerpt(content.summary)
    result.to_s.gsub(/\n+/, "\n")
  end
end
