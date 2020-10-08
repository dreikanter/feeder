require 'test_helper'
require_relative '../support/processor_test_helpers'

class InstagramProcessorTest < Minitest::Test
  include ProcessorTestHelpers

  def sample_data_file
    'feed_instagram.json'
  end

  def subject
    InstagramProcessor
  end

  def sample_json
    JSON.parse(sample_data)
  end

  def result
    @result ||= subject.call(sample_json, feed: build(:feed))
  end

  def test_array
    assert(result.is_a?(Array))
  end

  def test_ids
    result.each do |entity|
      expected_id = entity.content['shortcode']
      assert(expected_id)
      assert(entity.uid)
      assert_equal(expected_id, entity.uid)
    end
  end
end
