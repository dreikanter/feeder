require 'test_helper'

module API
  class FeedsRoutingTest < ActionDispatch::IntegrationTest
    include Rails.application.routes.url_helpers

    SAMPLE_FEED_NAME = 'xkcd'.freeze

    def test_feeds_index
      path = api_feeds_path

      expected = {
        controller: 'api/feeds',
        action: 'index',
        format: :json
      }

      options = {
        path: path,
        method: :get
      }

      assert_recognizes(expected, options)
    end

    def test_feeds_show
      path = api_feed_path(SAMPLE_FEED_NAME)

      expected = {
        controller: 'api/feeds',
        action: 'show',
        format: :json,
        name: SAMPLE_FEED_NAME
      }

      options = {
        path: path,
        method: :get,
        name: SAMPLE_FEED_NAME
      }

      assert_recognizes(expected, options)
    end
  end
end
