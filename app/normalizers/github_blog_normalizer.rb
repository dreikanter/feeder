class GithubBlogNormalizer < AtomNormalizer
  def text
    [super, "!#{link}"].join(separator)
  end

  def comments
    [content_excerpt]
  end

  def attachments
    [safe_image_url]
  end

  private

  def content_excerpt
    Html.comment_excerpt(safe_content)
  end

  DEFAULT_HOST = "blog.github.com".freeze
  DEFAULT_SCHEME = "https".freeze

  def safe_image_url
    value = Html.first_image_url(safe_content)
    return unless value
    uri = Addressable::URI.parse(value)
    uri.host ||= DEFAULT_HOST
    uri.scheme ||= DEFAULT_SCHEME
    uri.to_s
  end

  def safe_content
    content.content.try(:content) || ""
  end
end
