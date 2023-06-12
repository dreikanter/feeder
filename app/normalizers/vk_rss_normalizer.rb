class VkRssNormalizer < RssNormalizer
  protected

  def link
    content.link
  end

  def text
    Html.post_excerpt(
      paragraphs.first,
      link: content.link,
      separator: separator
    )
  end

  def comments
    processed_comments || []
  end

  def attachments
    [first_image_url]
  end

  private

  def processed_comments
    (paragraphs[1..] || []).map do |paragraph|
      result = Html.squeeze(paragraph.gsub(/^\s*🔗\s*/, ""))
      Html.comment_excerpt(result)
    end
  end

  def paragraphs
    @paragraphs ||= Html.paragraphs(content.description)
  end

  def first_image_url
    Html.first_image_url(content.description)
  end
end
