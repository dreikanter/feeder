module Normalizers
  class NewfluxNormalizer < Normalizers::FeedjiraNormalizer
    def comments
      [summary]
    end

    def attachments
      [image_url]
    end

    private

    def summary
      Service::Html.comment_excerpt(entity.summary)
    end

    COVER_QUERY = 'meta[name="twitter:image"]'

    def image_url
      Nokogiri::HTML(page_content).css(COVER_QUERY).first[:content]
    end

    def page_content
      RestClient.get(link).body
    end
  end
end
