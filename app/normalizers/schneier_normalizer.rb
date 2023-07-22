class SchneierNormalizer < AtomNormalizer
  def text
    [super, link].join(separator)
  end

  def comments
    [excerpt]
  end

  private

  def excerpt
    Html.comment_excerpt(content.content.content)
  end
end
