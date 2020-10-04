class RedakciyaNormalizer < YoutubeNormalizer
  protected

  def text
    title = entity.title.gsub(%r{\s+/\s+Редакция(/Исходники)?\Z}, '')
    [title, entity.url].join(separator)
  end
end
