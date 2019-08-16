module Normalizers
  class InfiniteimmortalbensNormalizer < RssNormalizer
    def text
      [super, link].join(separator)
    end

    def attachments
      Service::Html.image_urls(entity.content_encoded)
    end
  end
end
