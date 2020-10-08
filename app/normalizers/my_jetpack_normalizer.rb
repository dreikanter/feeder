class MyJetpackNormalizer < TumblrNormalizer
  protected

  def text
    [Html.text(content.description), link].join(separator)
  end
end
