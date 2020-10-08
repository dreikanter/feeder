class InfiniteimmortalbensNormalizer < RssNormalizer
  def text
    [super, link].join(separator)
  end

  def attachments
    Html.image_urls(content.content_encoded)
  end
end
