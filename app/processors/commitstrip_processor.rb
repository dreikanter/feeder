module Processors
  class CommitstripProcessor < Processors::RssProcessor
    def extra(item)
      {
        image_url: Nokogiri::HTML(item.content_encoded).css('img').first['src']
      }
    end
  end
end
