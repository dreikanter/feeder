module Service
  class NextbigfutureThumbnailFetcher
    CSS_SELECTOR = '.featured-thumbnail img'.freeze

    def self.call(url)
      html = RestClient.get(url).body
      elements = Nokogiri::HTML(html).css(CSS_SELECTOR)
      elements.first['src']
    rescue
      nil
    end
  end
end
