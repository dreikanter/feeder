module EntityNormalizers
  class GithubBlogNormalizer < EntityNormalizers::AtomNormalizer
    def text
      [super, "!#{link}"].join(separator)
    end

    def comments
      [content_excerpt]
    end

    def attachments
      [first_image_url]
    end

    private

    def content_excerpt
      Service::Html.comment_excerpt(entity.content.content)
    end

    def first_image_url
      Service::Html.first_image_url(entity.content.content)
    end
  end
end
