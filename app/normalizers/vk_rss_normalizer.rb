class VkRssNormalizer < RssNormalizer
  protected

  def link
    entity.link
  end

  def text
    Html.post_excerpt(paragraphs.first,
      link: entity.link, separator: separator)
  end

  def comments
    processed_comments || []
  end

  def attachments
    [first_image_url]
  end

  private

  def processed_comments
    (paragraphs[1..-1] || []).map do |paragraph|
      result = Html.squeeze(paragraph.gsub(/^\s*🔗\s*/, ''))
      Html.comment_excerpt(result)
    end
  end

  def paragraphs
    @paragraphs ||= Html.paragraphs(entity.description)
  end

  def first_image_url
    Html.first_image_url(entity.description)
  end
end
