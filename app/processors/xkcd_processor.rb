module Processors
  class XkcdProcessor < Processors::RssProcessor
    def preprocess(item)
      image = Nokogiri::HTML(item.description).css('img').first
      @extra = { image_url: image['src'] }
      @description = image['alt'] || ''
    end

    def description(item)
      @description
    end

    def extra(item)
      @extra
    end
  end
end
