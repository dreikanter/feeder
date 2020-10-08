class RedakciyaNormalizer < YoutubeNormalizer
  protected

  def text
    title = content.title.gsub(%r{\s+/\s+Редакция(/Исходники)?\Z}, '')
    [title, content.url].join(separator)
  end
end
