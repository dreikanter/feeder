require 'test_helper'
require_relative '../support/processor_test_helpers'

module Processors
  class InstagramProcessorTest < Minitest::Test
    include ProcessorTestHelpers

    def sample_data_file
      'feed_instagram.json'
    end

    def subject
      Processors::InstagramProcessor
    end

    def sample_json
      JSON.parse(sample_data)
    end

    def result
      @result ||= subject.call(sample_json, create(:feed))
    end

    def test_success
      assert(result.success?)
    end

    def test_array
      value = result.value!
      assert(value.is_a?(Array))
    end

    def test_ids
      result.value!.each do |entity|
        expected_id = entity[1]['shortcode']
        assert(expected_id)
        assert(entity[0])
        assert_equal(expected_id, entity[0])
      end
    end
  end
end
