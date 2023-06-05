class NitterLoader < BaseLoader
  DEFAULT_NITTER_URL = 'https://nitter.net'.freeze

  option(:nitter_url, optional: true, default: -> { DEFAULT_NITTER_URL })

  protected

  def perform
    RestClient.get(nitter_rss_url.to_s).body
  end

  private

  def nitter_rss_url
    URI.parse(nitter_url).merge("/#{twitter_user}/rss")
  end

  def twitter_user
    feed.options.fetch('twitter_user')
  end
end
