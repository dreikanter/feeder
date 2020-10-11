# frozen_string_literal: true

require 'test_helper'
require_relative '../support/normalizer_test_helper'

class BaseNormalizerTest < Minitest::Test
  include NormalizerTestHelper

  def subject
    BaseNormalizer
  end

  ENTITY = Object.new
  OPTIONS = {}.freeze

  def entity
    Entity.new(uid: 'uid', content: 'content', feed: feed)
  end

  def feed
    build(:feed)
  end

  def uid
    nil
  end

  def test_minimal_viable_inheritence
    normalizer = Class.new(subject)
    result = normalizer.call(entity)
    assert(result)
  end

  SAMPLE_ERRORS = ['sample error'].freeze

  def test_validation_errors
    normalizer = Class.new(subject) do
      define_method(:validation_errors) { SAMPLE_ERRORS }
    end

    result = normalizer.call(entity)
    assert_equal(result.validation_errors, SAMPLE_ERRORS)
  end

  def test_return_hash
    result = Class.new(subject).call(entity)
    assert(result.is_a?(NormalizedEntity))
  end

  INCOMPLETE_URL = '//example.com'

  def test_sanitize_attachments
    normalizer = Class.new(subject) do
      define_method(:attachments) { [INCOMPLETE_URL] }
    end

    result = normalizer.call(entity)
    expected = ["https:#{INCOMPLETE_URL}"]
    assert(expected, result.attachments)
  end

  NON_VALID_URL = ':'

  def test_require_valid_attachment_urls
    normalizer = Class.new(subject) do
      define_method(:attachments) { [NON_VALID_URL] }
    end

    assert_raises(StandardError) { normalizer.call(entity) }
  end

  def test_require_attachments_array
    normalizer = Class.new(subject) do
      define_method(:attachments) { nil }
    end

    assert_raises(StandardError) { normalizer.call(entity) }
  end

  def test_drop_empty_attachment_urls
    normalizer = Class.new(subject) do
      define_method(:attachments) { [nil, ''] }
    end

    result = normalizer.call(entity)
    assert(result.attachments.empty?)
  end

  def test_require_comments_array
    normalizer = Class.new(subject) do
      define_method(:comments) { nil }
    end

    assert_raises(StandardError) { normalizer.call(entity) }
  end

  def test_drop_empty_comments
    normalizer = Class.new(subject) do
      define_method(:comments) { [nil, ''] }
    end

    result = normalizer.call(entity)
    assert(result.comments.empty?)
  end
end
