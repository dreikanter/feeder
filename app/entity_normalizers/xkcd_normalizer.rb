module EntityNormalizers
  class XkcdNormalizer < EntityNormalizers::RssNormalizer
    def text
      [super, link].join(separator)
    end

    def attachments
      [image['src']]
    end

    def comments
      alt = image['alt'].to_s
      return [] if alt.empty?
      [Service::Html.comment_excerpt(Service::Html.squeeze(alt))]
    end

    def image
      @image ||= Nokogiri::HTML(entity.description).css('img:first').first
    end
  end
end
