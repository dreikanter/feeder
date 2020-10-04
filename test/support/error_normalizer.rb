class ErrorNormalizer < BaseNormalizer
  protected

  def payload
    raise 'normalizer error'
  end
end
