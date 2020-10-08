class LunarbaboonNormalizer < FeedjiraNormalizer
  protected

  def attachments
    [Html.first_image_url(content.summary)]
  end

  def validation_errors
    return ['image not present'] if attachments.blank?
    super
  end
end
