module EntityNormalizers
  class TheAtlanticPhotosNormalizer < EntityNormalizers::TumblrNormalizer
    def text
      [description, direct_link].reject(&:blank?).join(separator)
    end

    def direct_link
      RestClient.get(entity.link) do |response, request, result, &block|
        redirecting = [301, 302, 307].include?(response.code)
        redirecting ? response.headers[:location] : entity.link
      end
    end

    def attachments
      [ image_url ]
    end

    def comments
      [ photo_description_excerpt ]
    end

    private

    def description
      kill_newlines(Service::Html.excerpt(entity.description, length: limit))
    end

    def limit
      Const::Content::MAX_UNCOLLAPSED_POST_LENGTH -
        separator.length - link.length
    end

    def image_url
      Service::Html.first_image_url(entity.description)
    end

    def photo_description_excerpt
      kill_newlines(Service::Html.comment_excerpt(photo_description.text))
    end

    def photo_description
      Nokogiri::HTML(entity.description).css('figure > figcaption').first
    end

    def kill_newlines(text)
      text.to_s.gsub(/\s+/, ' ')
    end
  end
end
