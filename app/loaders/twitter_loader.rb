# TwitterLoader requires "twitter" block in the application credentials file
# to contain Twitter API access credentials. See REQUIRED_OPTIONS definition
# and 'twitter' gem documentation.
#
# Rails.application.credentials.twitter will be used unless loader options
# are defined during the loader instance initialization.
#
# SEE: https://www.rubydoc.info/gems/twitter

module Loaders
  class TwitterLoader < Base
    REQUIRED_OPTIONS = %i[
      consumer_key
      consumer_secret
      access_token
      access_token_secret
    ].freeze

    def call
      validate_options!
      client.user_timeline(twitter_user)
    end

    private

    def validate_options!
      options_or_defaults.each do |option_name|
        next if options_or_defaults[option_name].present?
        raise "required option '#{option_name}' is not defined"
      end
    end

    def client
      Twitter::REST::Client.new(safe_options)
    end

    def twitter_user
      feed.options.fetch('twitter_user')
    rescue KeyError
      raise "'twitter_user' option is not defined for '#{feed.name}' feed"
    end

    def options_or_defaults
      return options unless options.empty?
      Rails.application.credentials.twitter
    end

    def safe_options
      options_or_defaults.slice(*REQUIRED_OPTIONS)
    end
  end
end
