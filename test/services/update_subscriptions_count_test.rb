# frozen_string_literal: true

require 'test_helper'

class UpdateSubscriptionsCountTest < Minitest::Test
  def subject
    UpdateSubscriptionsCount
  end

  FEED_NAME = 'xkcd'

  def feed
    @feed ||= create(:feed, name: FEED_NAME, subscriptions_count: 0)
  end

  def setup
    super

    # TODO: Fix transactional tests
    Feed.delete_all

    stub_request(:get, "#{base_url}/v2/timelines/xkcd")
      .with(headers: { 'Authorization' => "Bearer #{token}" })
      .to_return(
        body: response_body.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
  end

  SUBSCRIBERS_COUNT = 2

  def response_body
    {
      timelines: {
        subscribers: SUBSCRIBERS_COUNT.times.map(&:to_s)
      }
    }
  end

  def token
    Rails.application.credentials.freefeed_token
  end

  def base_url
    Rails.application.credentials.freefeed_base_url
  end

  def test_update_subscriptions_count
    subject.call(feed.name)
    feed.reload
    assert_equal(SUBSCRIBERS_COUNT, feed.subscriptions_count)
  end
end
