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
        config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
        config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
        config.access_token = ENV['TWITTER_ACCESS_TOKEN']
        config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
      end
    end
  end
end
