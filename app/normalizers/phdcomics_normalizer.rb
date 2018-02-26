module Normalizers
  class PhdcomicsNormalizer < Normalizers::RssNormalizer
    def text
      [ super, link ].join(separator)
    end

    def attachments
      [ Nokogiri::HTML(entity.description).css('img').first['src'] ]
    end
  end
end
