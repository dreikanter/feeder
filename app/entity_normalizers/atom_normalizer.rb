module EntityNormalizers
  class AtomNormalizer < EntityNormalizers::Base
    def link
      entity.link.try(:href)
    end

    def published_at
      entity.published.try(:content) || entity.updated.try(:content)
    end

    def text
      entity.title.try(:content)
    end
  end
end
