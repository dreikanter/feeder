module Service
  class OglafCrowler
    HOST = 'www.oglaf.com'.freeze
    SCHEME = 'https'.freeze

    # Hard limit by Freefeed API
    MAX_ATTACHMENTS_COUNT = 20

    def self.call(url)
      next_url = url
      pages = []

      while next_url && pages.count < MAX_ATTACHMENTS_COUNT
        response = RestClient.get(next_url)
        html = Nokogiri::HTML(response.body)
        pages << html
        next_url = next_page_url(html)
      end

      pages
    end

    def self.next_page_url(html)
      return nil unless html.css('#nx').any?
      result = html.css('link[rel=next]').first.attributes['href'].value
      uri = Addressable::URI.parse(result)
      uri.host ||= HOST
      uri.scheme ||= SCHEME
      uri.to_s
    end
  end
end
