module Processors
  class CommitstripProcessor < Processors::RssProcessor
    def text(item)
      "#{item.title} - #{item.link}"
    end

    def attachments(item)
      [ Nokogiri::HTML(item.content_encoded).css('img').first['src'] ]
    end
  end
end
