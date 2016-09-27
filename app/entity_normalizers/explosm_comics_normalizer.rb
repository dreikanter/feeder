module EntityNormalizers
  class ExplosmComicsNormalizer < EntityNormalizers::RssNormalizer
    def text
      "#{super} - #{link}"
    end

    def attachments
      [image_url]
    end

    private

    def image_url
      @image_url ||= load_image_url
    end

    def normalized_image_uri
      uri = Addressable::URI.parse(load_image_url)
      uri.scheme ||= 'https'
      uri.to_s
    end

    def load_image_url
      Service::Html.first_image_url(page_content, '#main-comic')
    end

    def page_content
      RestClient.get(link).body
    end
  end
end
