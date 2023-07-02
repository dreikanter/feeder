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
    service_instance.fail! if service_instance.persisted? && service_instance.may_fail?
  end

  def nitter_rss_url
    URI.parse(service_instance.url).merge("/#{twitter_user}/rss")
  end

  def twitter_user
    feed.options.fetch("twitter_user")
  end

  def service_instance
    @service_instance ||= ServiceInstance.pick("nitter") || ServiceInstance.new(url: DEFAULT_INSTANCE)
  end
end
