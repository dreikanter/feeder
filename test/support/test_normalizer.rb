class TestNormalizer < BaseNormalizer
  protected

  def link
    content.fetch("link")
  end

  def text
    content.fetch("text")
  end

  def validation_errors
    [].tap do |errors|
      errors << "empty_link" if link.blank?
      errors << "empty_text" if text.blank?
    end
  end
end
