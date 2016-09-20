module EntityNormalizers
  class OglafNormalizer < EntityNormalizers::RssNormalizer
    def text
      "#{super} - #{link}"
    end

    def published_at
      @published_at ||= last_modified
    end

    def attachments
      @attachments ||= [image_url]
    end

    def last_modified
      DateTime.parse(response.headers[:last_modified])
    rescue
      DateTime.now
    end

    def image_url
      Nokogiri::HTML(response.body).css('img#strip:first').first[:src]
    rescue
      nil
    end

    def response
      @response ||= RestClient.get(link)
    end
  end
end
