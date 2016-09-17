module EntityNormalizers
  class RssNormalizer < EntityNormalizers::Base
    def link
      entity.link
    end

    def published_at
      entity.pubDate
    end

    def text
      entity.title
    end
  end
end
