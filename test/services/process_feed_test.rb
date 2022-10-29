# frozen_string_literal: true

require 'test_helper'
require_relative '../support/test_processor'
require_relative '../support/test_normalizer'

class ProcessFeedTest < Minitest::Test
  include ActiveJob::TestHelper

  def subject
    ProcessFeed
  end

  def setup
    super
    stub_feed_loader_request('feeds/test/feed.json')

    stub_request(:post, 'https://freefeed.net/v1/posts')
      .to_return(
        headers: { 'Content-Type' => 'application/json' },
        body: {
          posts: {
            id: 1
          }
        }.to_json
      )
  end

  FEED_URL = 'https://example.com/sample_feed'

  def feed
    @feed ||= create(
      :feed,
      name: :test,
      loader: :http,
      import_limit: 0,
      url: FEED_URL
    )
  end

  def posts
    feed.posts
  end

  def stub_feed_loader_request(fixture_path)
    stub_request(:get, FEED_URL).to_return(body: file_fixture(fixture_path))
  end

  EXPECTED_PUBLISHED_POSTS_COUNT = 2
  EXPECTED_ERRORED_POSTS_COUNT = 1

  def test_call
    subject.call(feed)
    assert_equal(EXPECTED_PUBLISHED_POSTS_COUNT, posts.published.count)
    assert_equal(EXPECTED_ERRORED_POSTS_COUNT, posts.not_valid.count)
  end

  def data_point
    DataPoint.for(:pull).last
  end

  def details
    data_point.details
  end

  def test_update_feed_timestamps
    freeze_time do
      subject.call(feed)
      assert_in_delta(0.0, details['duration'])
    end
  end

  def test_create_data_point
    subject.call(feed)
    assert_equal(details['feed_name'], 'test')
    assert_equal(details['posts_count'], EXPECTED_PUBLISHED_POSTS_COUNT + EXPECTED_ERRORED_POSTS_COUNT)
    assert_equal(details['errors_count'], EXPECTED_ERRORED_POSTS_COUNT)
  end
end
