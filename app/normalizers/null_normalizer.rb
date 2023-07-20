class NullNormalizer < BaseNormalizer
  protected

  def validation_errors
    ["missing normalizer"]
  end
end
