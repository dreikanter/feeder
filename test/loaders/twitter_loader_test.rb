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
    REQUIRED_OPTIONS.to_h { |option| [option, "#{option} value"] }
  end

  SAMPLE_RESULT = [].freeze

  # TODO: Use WebMock
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

    assert_equal(SAMPLE_RESULT, result)
  end

  def test_should_require_twitter_credentials
    assert_raises(RuntimeError) { loader.call(feed, credentials: {}) }
  end

  def test_require_twitter_user_in_feed_options
    sample_feed = build(:feed, :twitter, options: {})
    assert_raises(RuntimeError) { loader.call(sample_feed) }
  end
end
