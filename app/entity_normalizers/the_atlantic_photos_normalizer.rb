module EntityNormalizers
  class TheAtlanticPhotosNormalizer < EntityNormalizers::TumblrNormalizer
    def text
      [description, link].reject(&:blank?).join(separator)
    end

    def link
      @link ||= Service::Html.first_link_url(entity.description)
    end

    private

    def description
      Service::Html.excerpt(entity.description, max_length)
    end

    def max_length
      Const::Content::MAX_UNCOLLAPSED_POST_LENGTH -
        separator.length - link.length
    end
  end
end
