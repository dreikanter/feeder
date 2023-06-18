class RedditNormalizer < AtomNormalizer
  protected

  def link
    discussion_url
  end

  def text
    [super.sub(/\.$/, ""), source_url].join(separator)
  end

  def comments
    (source_url == discussion_url) ? [] : [discussion_url]
  end

  private

  def source_url
    @source_url ||= Html.link_urls(extract_content)[1]
  rescue StandardError
    @source_url ||= discussion_url
  end

  def discussion_url
    entity.content.link.href
  end

  def extract_content
    content.content.content
  end
end
