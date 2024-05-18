class PluralisticNormalizer < RssNormalizer
  include HttpClient

  def text
    [super, link].join(separator)
  end

  def attachments
    [cover_image]
  end

  private

  def cover_image
    Html.first_image_url(http.get(content.link).to_s)
  rescue StandardError
    nil
  end
end
