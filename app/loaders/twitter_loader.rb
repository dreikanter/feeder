# TwitterLoader requires 'twitter' block in the application credentials file
# to contain Twitter API access credentials. See REQUIRED_CREDENTIALS definition
# and 'twitter' gem documentation.
#
# Rails.application.credentials.twitter will be used unless twitter
# access credentials are defined in the 'credentials' loader option
# during the class instance initialization.
#
# SEE: https://www.rubydoc.info/gems/twitter
# SEE: https://developer.twitter.com/en/docs/twitter-api/v1/tweets/timelines/api-reference/get-statuses-user_timeline

class TwitterLoader < BaseLoader
  option(
    :credentials,
    optional: true,
    default: -> { Rails.application.credentials.twitter || {} }
  )

  option(
    :client,
    optional: true,
    default: -> { Twitter::REST::Client.new(safe_credentials) }
  )

  REQUIRED_CREDENTIALS = %i[
    consumer_key
    consumer_secret
    access_token
    access_token_secret
  ].freeze

  def call
    validate_credentials!
    client.user_timeline(twitter_user, tweet_mode: "extended")
  end

  private

  def validate_credentials!
    return if missing_credentials.empty?
    raise "missing credentials: #{missing_credentials.join(", ")}"
  end

  def missing_credentials
    REQUIRED_CREDENTIALS.select { |key| credentials[key].blank? }
  end

  def safe_credentials
    credentials.slice(*REQUIRED_CREDENTIALS)
  end

  def twitter_user
    feed.options.fetch("twitter_user")
  end
end
