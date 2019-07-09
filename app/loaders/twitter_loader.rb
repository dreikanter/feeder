# TwitterLoader requires 'twitter' block in the application credentials file
# to contain Twitter API access credentials. See REQUIRED_CREDENTIALS definition
# and 'twitter' gem documentation.
#
# Rails.application.credentials.twitter will be used unless twitter
# access credentials are defined in the 'credentials' loader option
# during the class instance initialization.
#
# SEE: https://www.rubydoc.info/gems/twitter

module Loaders
  class TwitterLoader < Base
    REQUIRED_CREDENTIALS = %i[
      consumer_key
      consumer_secret
      access_token
      access_token_secret
    ].freeze

    def call
      validate_credentials!
      client.user_timeline(twitter_user)
    end

    private

    def validate_credentials!
      return if missing_credentials.empty?

      raise "required credentials not found: #{missing_credentials.join(', ')}"
    end

    def missing_credentials
      REQUIRED_CREDENTIALS.select { |key| credentials[key].blank? }
    end

    def credentials
      options[:credentials] || Rails.application.credentials.twitter
    end

    def client
      options[:client] || twitter_client
    end

    def twitter_client
      Twitter::REST::Client.new(safe_credentials)
    end

    def safe_credentials
      credentials.slice(*REQUIRED_CREDENTIALS)
    end

    def twitter_user
      feed.options.fetch('twitter_user')
    rescue KeyError
      raise "'twitter_user' not defined in '#{feed.name}' feed options"
    end
  end
end
