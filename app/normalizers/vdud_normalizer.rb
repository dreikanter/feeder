class VdudNormalizer < YoutubeNormalizer
  protected

  def text
    title = entity.title.gsub(%r{\s+/\s+вДудь\Z}, '')
    [title, entity.url].join(separator)
  end
end
