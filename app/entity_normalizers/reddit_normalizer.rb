module EntityNormalizers
  class RedditNormalizer < EntityNormalizers::AtomNormalizer
    def link
      discussion_url
    end

    def text
      [super.sub(/\.$/, ''), source_url].join(separator)
    end

    def comments
      return [] if source_url == discussion_url
      [ "Discussion: #{discussion_url}" ]
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
  end
end
