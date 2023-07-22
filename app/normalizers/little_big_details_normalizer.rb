class LittleBigDetailsNormalizer < TumblrNormalizer
  def text
    [description, link].join(separator)
  end

  private

  def description
    Html.text(content.description)
  end
end
