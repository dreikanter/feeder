module Normalizers
  class TheycantalkNormalizer < Normalizers::TumblrNormalizer
    def text
      [post_excerpt, link].reject(&:blank?).join(separator)
    end

    def attachments
      [image_url]
    end

    def comments
      paragraphs[1..-1] || []
    end

    private

    def image_url
      Service::Html.first_image_url(entity.description)
    end

    def post_excerpt
      Service::Html.post_excerpt(paragraphs.first)
    end

    def paragraphs
      @paragraphs ||= Service::Html.paragraphs(entity.description)
    end
  end
end
