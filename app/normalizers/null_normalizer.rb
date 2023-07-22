class NullNormalizer < BaseNormalizer
  def validation_errors
    ["missing normalizer"]
  end
end
