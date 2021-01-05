class VdudNormalizer < YoutubeNormalizer
  protected

  def text
    title = content.title.gsub(%r{\s+/\s+вДудь\Z}, '')
    [title, content.url].join(separator)
  end

  def comments
    []
  end
end
