class TheAtlanticPhotosNormalizer < FeedjiraNormalizer
  def text
    [caption, link].compact_blank.join(separator)
  end

  def attachments
    [headline_image_url].compact_blank
  end

  def comments
    [content.summary].compact_blank
  end

  def validation_errors
    super + (attachments.none? ? ["no images"] : [])
  end

  private

  def headline_image_url
    content.image || legacy_format_image_url
  end

  def legacy_format_image_url
    Nokogiri::HTML(content.content).css("figure img").first["src"]
  end

  def caption
    content_title = content.title
    content_author = content.author

    if content_title.present?
      content_author.present? ? "#{content_title} (#{content_author})" : content_title
    else
      "Untitled"
    end
  end
end
