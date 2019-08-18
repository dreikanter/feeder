class LittleBigDetailsNormalizer < TumblrNormalizer
  protected

  def text
    [description, link].join(separator)
  end

  private

  def description
    Html.text(entity.description)
  end
end
