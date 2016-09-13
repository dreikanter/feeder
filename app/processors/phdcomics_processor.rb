module Processors
  class PhdcomicsProcessor < Processors::RssProcessor
    def text(item)
      "#{item.title} - #{item.link}"
    end

    def attachments(item)
      [ Nokogiri::HTML(item.description).css('img').first['src'] ]
    end
  end
end
