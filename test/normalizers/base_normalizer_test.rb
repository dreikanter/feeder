require 'test_helper'
require_relative '../support/normalizer_test_helper'

class BaseNormalizerTest < Minitest::Test
  include NormalizerTestHelper

  def subject
    BaseNormalizer
  end

  ENTITY = Object.new
  OPTIONS = {}.freeze

  def feed
    build(:feed)
  end

  def uid
    nil
  end

  def test_accept_entity
    subject.call(uid, ENTITY, feed)
  end

  def test_success_normalizer
    result = Class.new(subject).call(uid, ENTITY, feed)
    assert(result.success?)
  end

  EXPECTED_ATTRIBUTES = %i[
    attachments
    comments
    link
    published_at
    text
    uid
    validation_errors
  ].to_set.freeze

  def test_minimal_viable_inheritence
    normalizer = Class.new(subject)
    result = normalizer.call(uid, ENTITY, feed)
    assert(result.success?)
  end

  SAMPLE_ERRORS = ['sample error'].freeze

  def test_validation_errors
    normalizer = Class.new(subject) do
      define_method(:validation_errors) { SAMPLE_ERRORS }
    end
    result = normalizer.call(uid, ENTITY, feed)
    assert(result.success?)
    assert_equal(result.value![:validation_errors], SAMPLE_ERRORS)
  end

  def test_return_hash
    result = Class.new(subject).call(uid, ENTITY, feed).value!
    assert_equal(EXPECTED_ATTRIBUTES, result.keys.to_set)
  end

  def test_sanitize_attachments
    incomplete_url = '//example.com'
    normalizer = Class.new(subject) do
      define_method(:attachments) { [incomplete_url] }
    end
    result = normalizer.call(uid, ENTITY, feed)
    expected = ["https:#{incomplete_url}"]
    assert(expected, result.value![:attachments])
  end

  def test_require_valid_attachment_urls
    non_valid_url = ':'
    normalizer = Class.new(subject) do
      define_method(:attachments) { [non_valid_url] }
    end
    result = normalizer.call(uid, ENTITY, feed)
    assert(result.failure?)
  end

  def test_require_attachments_array
    normalizer = Class.new(subject) do
      define_method(:attachments) { nil }
    end
    result = normalizer.call(uid, ENTITY, feed)
    assert(result.failure?)
  end

  def test_drop_empty_attachment_urls
    normalizer = Class.new(subject) do
      define_method(:attachments) { [nil, ''] }
    end
    result = normalizer.call(uid, ENTITY, feed)
    assert(result.value![:attachments].empty?)
  end

  def test_require_comments_array
    normalizer = Class.new(subject) do
      define_method(:comments) { nil }
    end
    result = normalizer.call(uid, ENTITY, feed)
    assert(result.failure?)
  end

  def test_drop_empty_comments
    normalizer = Class.new(subject) do
      define_method(:comments) { [nil, ''] }
    end
    result = normalizer.call(uid, ENTITY, feed)
    assert(result.value![:comments].empty?)
  end
end
