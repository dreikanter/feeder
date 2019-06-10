module Loaders
  class TwitterLoader < Base
    def call
      client.user_timeline(twitter_user)
    end

    private

    def twitter_user
      feed.options.fetch('twitter_user')
    rescue KeyError
      raise "the feed '#{feed.name}' don't have 'twitter_user' option defined"
    end

    def client
      @client ||= Twitter::REST::Client.new do |config|
        config.consumer_key =
          Rails.application.credentials.twitter_consumer_key

        config.consumer_secret =
          Rails.application.credentials.twitter_consumer_secret

        config.access_token =
          Rails.application.credentials.twitter_access_token

        config.access_token_secret =
          Rails.application.credentials.twitter_access_token_secret
      end
    end
  end
end
