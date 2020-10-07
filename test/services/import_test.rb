# frozen_string_literal: true

require 'test_helper'
require_relative '../support/test_processor'
require_relative '../support/test_normalizer'

class ImportTest < Minitest::Test
  include ActiveJob::TestHelper

  def subject
    Import
  end

  def setup
    Feed.delete_all
    Post.delete_all
    stub_feed_loader_request('feeds/test_feed.json')
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

  EXPECTED_JOBS_COUNT = 2
  EXPECTED_POSTS_COUNT = 2
  EXPECTED_ERRORS_COUNT = 1

  def test_call
    assert_enqueued_jobs(EXPECTED_JOBS_COUNT, only: PushJob) do
      subject.call(feed)
    end

    assert_equal(posts.ready.count, EXPECTED_POSTS_COUNT)
    assert_equal(posts.ignored.count, EXPECTED_ERRORS_COUNT)
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
    assert_equal(details['posts_count'], EXPECTED_POSTS_COUNT + EXPECTED_ERRORS_COUNT)
    assert_equal(details['errors_count'], EXPECTED_ERRORS_COUNT)
  end
end
