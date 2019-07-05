module Normalizers
  class RssNormalizer < Normalizers::Base
    protected

    def link
      entity.link
    end

    def published_at
      entity.respond_to?(:pubDate) ? entity.pubDate : entity.dc_date
    end

    def text
      entity.title
    end
  end
end
