require 'test_helper'
require_relative '../support/normalizer_test_helper'

class NormalizerBaseTest < Minitest::Test
  include NormalizerTestHelper

  def subject
    Normalizers::Base
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

  EXPECTED_ATTRIBUTES = %w[
    attachments
    comments
    link
    published_at
    text
    uid
  ].to_set.freeze

  def test_return_attributes_hash
    result = Class.new(subject).call(uid, ENTITY, feed).value!
    assert_equal(EXPECTED_ATTRIBUTES, result.keys.to_set)
  end

  def test_failure_normalizer
    normalizer = Class.new(subject) do
      define_method('validation_errors') { ['sample error'] }
    end
    result = normalizer.call(uid, ENTITY, feed)
    assert(result.failure?)
  end
end
