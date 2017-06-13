module EntityNormalizers
  class TelegaNormalizer < EntityNormalizers::RssNormalizer
    def text
      Service::Html.post_excerpt(paragraphs.first,
        link: entity.link, separator: separator)
    end

    def comments
      [paragraphs[1..-1].join("\n\n")] || []
    end

    private

    def paragraphs
      @paragraphs ||= Service::Html.paragraphs(entity.description)
    end
  end
end
