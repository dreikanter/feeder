module EntityNormalizers
  class CommitstripNormalizer < EntityNormalizers::RssNormalizer
    def text
      "#{entity.title} - #{entity.link}"
    end

    def attachments
      [ Nokogiri::HTML(entity.content_encoded).css('img:first').first['src'] ]
    end
  end
end
