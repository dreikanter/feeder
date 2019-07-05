module Normalizers
  class TelegaNormalizer < Normalizers::RssNormalizer
    protected

    def text
      Service::Html.post_excerpt(
        paragraphs.first,
        link: sanitized_link,
        separator: separator
      )
    end

    def sanitized_link
      entity.link.to_s.gsub(/^\/\//, 'https://')
    end

    def comments
      [excerpt] || []
    end

    private

    def excerpt
      Service::Html.comment_excerpt((paragraphs[1..-1] || []).join("\n\n"))
    end

    def paragraphs
      @paragraphs ||= Service::Html.paragraphs(entity.description)
    end
  end
end
