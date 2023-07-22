class MyJetpackNormalizer < TumblrNormalizer
  def text
    [Html.text(content.description), link].join(separator)
  end
end
