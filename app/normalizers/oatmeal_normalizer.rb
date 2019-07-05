module Normalizers
  class OatmealNormalizer < Normalizers::RssNormalizer
    protected

    def text
      [super, "!#{link}"].join(separator)
    end

    def attachments
      [image_url]
    rescue
      []
    end

    def image_url
      Nokogiri::HTML(entity.description).css('img').first['src']
    end
  end
end
