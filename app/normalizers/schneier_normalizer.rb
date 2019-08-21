class SchneierNormalizer < AtomNormalizer
  protected

  def text
    [super, link].join(separator)
  end

  def comments
    [excerpt]
  end

  def excerpt
    Html.comment_excerpt(entity.content.content)
  end
end
