module Processors
  class PhdcomicsProcessor < Processors::RssProcessor
    def description(item)
      ''
    end

    def extra(item)
      { image_url: Nokogiri::HTML(item.description).css('img').first['src'] }
    end
  end
end
