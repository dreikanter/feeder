module Normalizers
  class WumoNormalizer < Normalizers::RssNormalizer
    protected

    def text
      [super, link].join(separator)
    end

    def published_at
      DateTime.new(*link.split('/').slice(-3, 3).map(&:to_i))
    rescue
      Rails.logger.error "error parsing date from url: #{link}"
      nil
    end

    def attachments
      [image_url]
    end

    def image_url
      Nokogiri::HTML(entity.description).css('img:first').first[:src]
    end
  end
end
