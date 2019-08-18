require 'test_helper'
require_relative '../support/normalizer_test_helper'

class InfiniteimmortalbensNormalizerTest < Minitest::Test
  include NormalizerTestHelper

  def subject
    InfiniteimmortalbensNormalizer
  end

  def processor
    RssProcessor
  end

  def sample_data_file
    'feed_infiniteimmortalbens.xml'.freeze
  end

  def test_success
    normalized.each do |entity|
      assert(entity.success?)
    end
  end

  def test_text
    normalized.each do |entity|
      refute(entity.value!['text'].empty?)
    end
  end

  def test_comments
    normalized.each do |entity|
      assert(entity.value!['comments'].empty?)
    end
  end

  def test_valid_link
    normalized.each do |entity|
      Addressable::URI.parse(entity.value!['link'])
    end
  end

  def test_published_at
    normalized.each do |entity|
      assert(entity.value!['published_at'].is_a?(Time))
    end
  end

  def test_attachments
    normalized.each do |entity|
      result = entity.value!['attachments']
      assert(result.is_a?(Array))
      assert(result.any?)
    end
  end
end
