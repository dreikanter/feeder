class MelodymaeNormalizer < FeedjiraNormalizer
  def comments
    []
  end

  def attachments
    [Html.first_image_url(content.content.to_s)]
  end
end
