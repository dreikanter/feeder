module EntityNormalizers
  class VkRssNormalizer < EntityNormalizers::RssNormalizer
    def link
      entity.link
    end

    def text
      Service::Html.post_excerpt(paragraphs.first,
        link: entity.link, separator: separator)
    end

    def comments
      paragraphs[1..-1].map { |p| p.gsub(/^\s*🔗\s*/, '') } || []
    end

    def attachments
      [first_image_url]
    end

    private

    def paragraphs
      @paragraphs ||= Service::Html.paragraphs(entity.description)
    end

    def first_image_url
      Service::Html.first_image_url(entity.description)
    end
  end
end
