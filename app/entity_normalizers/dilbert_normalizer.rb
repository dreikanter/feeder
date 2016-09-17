module EntityNormalizers
  class DilbertNormalizer < EntityNormalizers::AtomNormalizer
    def text
      "#{super} - #{link}"
    end

    def published_at
      DateTime.parse(link.split('/').last)
    rescue
      Rails.logger.error "error parsing date from url: #{link}"
      nil
    end

    def attachments
      [image_url]
    end

    def image_url
      @image_url ||= load_image_url
    end

    def load_image_url
      Nokogiri::HTML(page_content).css('img.img-comic:first').first[:src]
    end

    def page_content
      RestClient.get(link).body
    end
  end
end
