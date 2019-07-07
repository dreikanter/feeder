require 'test_helper'

module Loaders
  class BaseLoaderTest < Minitest::Test
    def loader
      Loaders::Base
    end

    def sample_feed
      @sample_feed ||= create(:feed)
    end

    def test_class_should_be_callable
      assert_respond_to(loader, :call)
    end

    def test_instance_should_be_callable
      assert_respond_to(loader.new(sample_feed), :call)
    end

    def test_should_accept_feed_param
      instance = loader.new(sample_feed)
      assert_equal(sample_feed, instance.feed)
    end

    def test_should_require_feed_param
      assert_raises(ArgumentError) { loader.new }
    end

    SAMPLE_OPTIONS = { client: 'twitter client' }.freeze

    def test_should_accept_options
      instance = loader.new(nil, SAMPLE_OPTIONS)
      assert_equal(SAMPLE_OPTIONS, instance.options)
    end
  end
end
