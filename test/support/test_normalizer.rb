class TestNormalizer < BaseNormalizer
  protected

  def link
    entity.fetch('link')
  end

  def text
    entity.fetch('text')
  end

  def validation_errors
    [].tap do |errors|
      errors << 'empty_link' unless link.present?
      errors << 'empty_text' unless text.present?
    end
  end
end
