module Normalizers
  class ExplosmComicsNormalizer < Normalizers::RssNormalizer
    protected

    def text
      [super, link].join(separator)
    end

    def attachments
      [image_url]
    end

    private

    def image_url
      @image_url ||= normalized_image_uri
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
