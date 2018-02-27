module Normalizers
  class CodingHorrorNormalizer < Normalizers::RssNormalizer
    def text
      [super, link].join(separator)
    end

    def attachments
      [image_url]
    end

    private

    def image_url
      Service::Html.first_image_url(entity.content_encoded)
    end
  end
end
