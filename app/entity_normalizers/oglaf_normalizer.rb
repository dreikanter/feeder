module EntityNormalizers
  class OglafNormalizer < EntityNormalizers::RssNormalizer
    def text
      [super, link].join(separator)
    end

    def published_at
      @published_at ||= last_modified
    end

    def attachments
      [ image_url ]
    end

    def comments
      [ image_title ]
    end

    def last_modified
      DateTime.parse(response.headers[:last_modified])
    rescue
      DateTime.now
    end

    def image_url
      image_element[:src]
    rescue
      nil
    end

    def image_title
      image_element[:title]
    end

    def image_element
      @image_element ||= Nokogiri::HTML(response.body).css('img#strip:first').first
    end

    def response
      @response ||= RestClient.get(link)
    end
  end
end
