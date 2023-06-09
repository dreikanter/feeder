class FaultyNormalizer < BaseNormalizer
  def call
    raise
  end
end
