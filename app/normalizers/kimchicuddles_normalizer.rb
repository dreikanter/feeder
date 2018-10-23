module Normalizers
  class KimchicuddlesNormalizer < Normalizers::Base
    def text
      entity.url
    end

    def link
      entity.url
    end

    def published_at
      entity.published
    end

    def attachments
      [image_url]
    end

    def comments
      [description]
    end

    private

    def image_url
      Service::Html.first_image_url(entity.summary)
    end

    def description
      result = Service::Html.comment_excerpt(entity.summary)
      result.to_s.gsub(/\n+/, "\n")
    end
  end
end
