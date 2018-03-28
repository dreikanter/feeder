module Normalizers
  class MaremirNormalizer < Normalizers::RssNormalizer
    def text
      [super, description, link].join(separator)
    end

    def attachments
      [first_image_url]
    end

    private

    def first_image_url
      Service::Html.first_image_url(safe_content)
    end

    def safe_content
      entity.content_encoded || ''
    end

    def description
      Service::Html.comment_excerpt(entity.description)
    end
  end
end
