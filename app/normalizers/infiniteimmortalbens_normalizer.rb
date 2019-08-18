class InfiniteimmortalbensNormalizer < RssNormalizer
  def text
    [super, link].join(separator)
  end

  def attachments
    Html.image_urls(entity.content_encoded)
  end
end
