module EntityNormalizers
  class AtomNormalizer < EntityNormalizers::Base
    def link
      entity.link.href
    end

    def published_at
      entity.updated.content
    end

    def text
      entity.title.content
    end
  end
end
