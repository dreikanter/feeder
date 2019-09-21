class System32Normalizer < InstagramNormalizer
  protected

  def link
    [BASE_URL, entity['shortcode']].join
  end

  def content
    super.split("\n.\n").first
  end

  def attachments
    result = super
    return result[0..-2] if result.length > 1
    result
  end
end
