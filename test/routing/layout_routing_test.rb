require 'test_helper'

class LayoutRoutingTest < ActionDispatch::IntegrationTest
  include Rails.application.routes.url_helpers

  SAMPLE_FEED_NAME = 'xkcd'.freeze

  def expected_options
    {
      controller: 'layout',
      action: 'show'
    }
  end

  def test_feeds_index
    path = feeds_path
    assert_recognizes(expected_options, path: path, method: :get)
  end

  def test_feed_show
    path = feed_path(SAMPLE_FEED_NAME)
    assert_recognizes(
      expected_options.merge(name: SAMPLE_FEED_NAME),
      path: path,
      method: :get,
      name: SAMPLE_FEED_NAME
    )
  end

  def test_updates_index
    path = updates_path
    assert_recognizes(expected_options, path: path, method: :get)
  end

  def test_posts_index
    path = posts_path
    assert_recognizes(expected_options, path: path, method: :get)
  end
end
