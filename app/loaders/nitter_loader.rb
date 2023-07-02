class NitterLoader < BaseLoader
  DEFAULT_INSTANCE = "https://nitter.net".freeze

  def call
    RestClient.get(nitter_rss_url.to_s).body
  rescue StandardError => e
    # TODO: Do not treat 404 as instance availability
    ErrorDumper.call(exception: e, message: "Nitter error", target: feed)
    register_nitter_instance_error
    raise
  end

  private

  def register_nitter_instance_error
    NitterInstance.find_or_create_by(url: nitter_url).error!
  end

  def nitter_rss_url
    URI.parse(nitter_url).merge("/#{twitter_user}/rss")
  end

  def twitter_user
    feed.options.fetch("twitter_user")
  end

  def nitter_url
    ServiceInstance.pick_url("nitter", default: DEFAULT_INSTANCE)
  end
end
