require_relative 'normalizer_test'

class NormalizerBaseTest < NormalizerTest
  def subject
    Normalizers::Base
  end

  def test_is_callable
    subject.respond_to?(:call)
  end

  ENTITY = Object.new
  OPTIONS = {}.freeze

  def test_accept_entity
    subject.call(ENTITY, OPTIONS)
  end

  class SuccessNormalizer < Normalizers::Base
  end

  def test_success_normalizer
    result = SuccessNormalizer.call(ENTITY, OPTIONS)
    assert(result.is_a?(Success))
  end

  EXPECTED_ATTRIBUTES = %w[
    attachments
    comments
    link
    published_at
    text
  ].to_set.freeze

  def test_return_attributes_hash
    result = SuccessNormalizer.call(ENTITY, OPTIONS)
    assert_equal(EXPECTED_ATTRIBUTES, result.payload.keys.to_set)
  end

  class FailureNormalizer < Normalizers::Base
    def validation_errors
      ['sample error']
    end
  end

  def test_failure_normalizer
    result = FailureNormalizer.call(ENTITY, OPTIONS)
    assert(result.is_a?(Failure))
  end
end
