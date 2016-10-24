module EntityNormalizers
  class OatmealNormalizer < EntityNormalizers::RssNormalizer
    def text
      [super, "!#{link}"].join(separator)
    end

    def attachments
      [image_url]
    rescue
      []
    end

    def image_url
      Nokogiri::HTML(entity.description).css('img').first['src']
    end
  end
end
