module EntityNormalizers
  class PhdcomicsNormalizer < EntityNormalizers::RssNormalizer
    def text
      "#{entity.title} - #{entity.link}"
    end

    def attachments
      [ Nokogiri::HTML(entity.description).css('img').first['src'] ]
    end
  end
end
