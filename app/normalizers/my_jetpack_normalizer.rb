class MyJetpackNormalizer < TumblrNormalizer
  protected

  def text
    [Html.text(entity.description), link].join(separator)
  end
end
