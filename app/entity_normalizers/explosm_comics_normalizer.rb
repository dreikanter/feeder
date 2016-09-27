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

    def load_image_url
      uri = Service::Html.first_image_url(page_content, '#main-comic')
      uri = Addressable::URI.parse(uri)
      uri.scheme ||= 'https'
      uri.to_s
    end

    def page_content
      RestClient.get(link).body
    end
  end
end
