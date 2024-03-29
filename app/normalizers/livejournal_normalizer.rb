class LivejournalNormalizer < RssNormalizer
  def text
    [super, "!#{link}"].compact_blank.join(separator)
  end

  def comments
    [excerpt]
  end

  def attachments
    [first_image_url]
  rescue StandardError
    []
  end

  private

  def first_image_url
    @first_image_url ||= Html.first_image_url(content.description)
  end

  def excerpt
    @excerpt ||= Html.comment_excerpt(content.description)
  end
end
