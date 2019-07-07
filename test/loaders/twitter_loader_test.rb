require 'test_helper'

module Loaders
  class TwitterLoaderTest < Minitest::Test
    def loader
      Loaders::TwitterLoader
    end

    SAMPLE_OPTIONS = [].freeze

    REQUIRED_OPTIONS = %i[
      consumer_key
      consumer_secret
      access_token
      access_token_secret
    ].freeze

    def sample_options
      {
        credentials: sample_credentials,
        client: twitter_client_mock
      }
    end

    def sample_credentials
      REQUIRED_OPTIONS.map { |option| [option, "#{option} value"] }.to_h
    end

    SAMPLE_RESULT = [].freeze

    def twitter_client_mock
      client = mock
      client.stubs(:user_timeline).returns(SAMPLE_RESULT)
      client
    end

    def twitter_feed
      @feed ||= create(:feed, :twitter)
    end

    def test_should_fetch_data_from_twitter
      result = loader.call(twitter_feed, sample_options)
      assert_equal(SAMPLE_RESULT, result)
    end

    def test_should_require_twitter_credentials
      assert_raises RuntimeError do
        loader.call(twitter_feed, credentials: {})
      end
    end
  end
end
