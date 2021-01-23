require 'test_helper'

class TwitterTest < Minitest::Test
  include FeedTestHelper

  def setup
    super

    # SEE: https://developer.twitter.com/en/docs/twitter-api/v1/tweets/timelines/api-reference/get-statuses-user_timeline
    stub_request(:get, 'https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=alg_testament&tweet_mode=extended')
      .to_return(
        headers: { 'Content-Type' => 'application/json' },
        body: file_fixture('api/twitter/user_timeline.json').read
      )
  end

  def feed_config
    {
      loader: 'twitter',
      processor: 'twitter',
      normalizer: 'twitter',
      options: {
        twitter_user: 'alg_testament'
      }
    }
  end

  def source_fixture_path
    'feeds/twitter.json'
  end

  def expected_fixture_path
    'entities/twitter.json'
  end
end
