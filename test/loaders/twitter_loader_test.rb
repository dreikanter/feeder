require 'test_helper'

class TwitterLoaderTest < Minitest::Test
  def loader
    TwitterLoader
  end

  REQUIRED_OPTIONS = %i[
    consumer_key
    consumer_secret
    access_token
    access_token_secret
  ].freeze

  def sample_credentials
    REQUIRED_OPTIONS.map { |option| [option, "#{option} value"] }.to_h
  end

  SAMPLE_RESULT = [].freeze

  def twitter_client_mock
    client = mock
    client.stubs(:user_timeline).returns(SAMPLE_RESULT)
    client
  end

  def feed
    build(:feed, :twitter)
  end

  def test_should_fetch_data_from_twitter
    result = loader.call(
      feed,
      credentials: sample_credentials,
      client: twitter_client_mock
    )
    assert(result.success?)
    assert_equal(SAMPLE_RESULT, result.value!)
  end

  def test_should_require_twitter_credentials
    result = loader.call(feed, credentials: {})
    assert(result.failure?)
  end

  def test_require_twitter_user_in_feed_options
    sample_feed = build(:feed, :twitter, options: {})
    result = loader.call(sample_feed)
    assert(result.failure?)
    assert(result.failure.is_a?(KeyError))
  end
end
