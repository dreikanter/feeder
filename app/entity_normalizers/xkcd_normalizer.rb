module EntityNormalizers
  class XkcdNormalizer < EntityNormalizers::RssNormalizer
    def text
      "#{entity.title} - #{entity.link}"
    end

    def attachments
      [image['src']]
    end

    def comments
      (image['alt'].to_s.empty? ? [] : [image['alt']])
    end

    def image
      @image ||= Nokogiri::HTML(entity.description).css('img:first').first
    end
  end
end
