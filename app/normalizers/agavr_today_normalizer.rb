module Normalizers
  class AgavrTodayNormalizer < Normalizers::TelegaNormalizer
    def attachments
      return [image_url] if image_url.present?
      []
    end

    private

    def image_url
      Service::Html.first_image_url(entity.description)
    end
  end
end
