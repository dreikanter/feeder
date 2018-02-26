module Normalizers
  class TumblrNormalizer < Normalizers::RssNormalizer
    def text
      [super, link].join(separator)
    end

    def attachments
      [image_url]
    end

    private

    def image_url
      Service::Html.first_image_url(entity.description)
    end
  end
end
