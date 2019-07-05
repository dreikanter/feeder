module Normalizers
  class MaremirNormalizer < Normalizers::RssNormalizer
    WORDPRESS_THUMBNAIL_SUFFIX = '-150x150.'

    protected

    def text
      [super, description, link].join(separator)
    end

    def attachments
      [first_image_url]
    end

    private

    def first_image_url
      url = Service::Html.first_image_url(safe_content)
      url.to_s.gsub(WORDPRESS_THUMBNAIL_SUFFIX, '.')
    end

    def safe_content
      entity.content_encoded || ''
    end

    def description
      Service::Html.comment_excerpt(entity.description)
    end
  end
end
