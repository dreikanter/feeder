class AgavrTodayNormalizer < TelegaNormalizer
  protected

  def attachments
    return [image_url] if image_url.present?
    []
  end

  private

  def image_url
    Html.first_image_url(entity.description)
  end
end
