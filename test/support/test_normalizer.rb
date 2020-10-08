class TestNormalizer < BaseNormalizer
  protected

  def link
    content.fetch('link')
  end

  def text
    content.fetch('text')
  end

  def validation_errors
    [].tap do |errors|
      errors << 'empty_link' unless link.present?
      errors << 'empty_text' unless text.present?
    end
  end
end
