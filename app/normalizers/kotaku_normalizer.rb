class KotakuNormalizer < BaseNormalizer
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
end
