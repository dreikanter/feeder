module Processors
  class XkcdProcessor < Processors::RssProcessor
    def process_item(item)
      @image = Nokogiri::HTML(item.description).css('img').first
      super
    end

    def text(item)
      "#{item.title} - #{item.link}"
    end

    def attachments(item)
      [@image['src']]
    end

    def comments(item)
      @image['alt'].to_s.empty? ? [] : [@image['alt']]
    end
  end
end
