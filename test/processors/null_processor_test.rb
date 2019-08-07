require 'test_helper'

module Processors
  class NullProcessorTest < Minitest::Test
    def subject
      Processors::NullProcessor
    end

    def test_returns_empty_hash
      source = nil
      feed = create(:feed)
      result = subject.call(source, feed)
      assert(result.success?)
      assert_equal([], result.value!)
    end
  end
end
