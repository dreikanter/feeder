module Normalizers
  class BlogdummiNormalizer < Normalizers::Base
    protected

    def link
      entity.url
    end

    def published_at
      entity.published
    end

    def text
      [entity.title, link].join(separator)
    end

    def attachments
      [image_url]
    end

    def comments
      [description]
    end

    private

    def image_url
      Service::Html.first_image_url(entity.content)
    end

    def description
      excerpt = Service::Html.squeeze(entity.content)
      Service::Html.comment_excerpt(excerpt)
    end
  end
end
