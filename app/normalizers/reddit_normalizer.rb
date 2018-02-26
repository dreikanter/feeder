module Normalizers
  class RedditNormalizer < Normalizers::AtomNormalizer
    def link
      discussion_url
    end

    def text
      [ super.sub(/\.$/, ''), source_url ].join(separator)
    end

    def comments
      return [] if source_url == discussion_url
      parts = [ reddit_info, discussion_url ]
      [ parts.reject(&:blank?).join(' - ') ]
    end

    private

    def source_url
      @source_url ||= Service::Html.link_urls(content)[1]
    rescue
      @source_url ||= discussion_url
    end

    def discussion_url
      entity.link.href
    end

    def content
      entity.content.content
    end

    def reddit_info
      cached_data_point(entity.link.href).details.try(:[], 'description')
    end

    def cached_data_point(link)
      DataPoint.for(:reddit).where("details->>'link' = ?", link).ordered.first
    end
  end
end
