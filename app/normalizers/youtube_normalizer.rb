module Normalizers
  class YoutubeNormalizer < Normalizers::Base
    def link
      entity.url
    end

    def published_at
      entity.published
    end

    def text
      [entity.title, entity.url].join(separator)
    end

    def comments
      [Service::Html.comment_excerpt(entity.content)]
    end
  end
end
