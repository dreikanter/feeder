module EntityNormalizers
  class EsquirePhotosNormalizer < EntityNormalizers::RssNormalizer
    def text
      [description, link].reject(&:blank?).join(separator)
    end

    def published_at
      parts = /(\d\d)(\d\d)(\d\d\d\d)/.match(link)
      DateTime.new(Integer(parts[3]), Integer(parts[2]), Integer(parts[1]))
    rescue
      DateTime.now
    end

    def attachments
      [image_url]
    end

    private

    def image_url
      Service::Html.first_image_url(entity.description)
    end

    READ_MORE_LINK = /\s*Читать дальше\s*/.freeze

    def description
      Service::Html.excerpt(entity.description, length: max_length).
        gsub(READ_MORE_LINK, '')
    end

    def max_length
      Const::Content::MAX_UNCOLLAPSED_POST_LENGTH -
        separator.length - link.length
    end
  end
end
