class NitterLoader < BaseLoader
  DEFAULT_INSTANCE = "https://nitter.net".freeze

  def call
    response = HTTP.timeout(5).get(nitter_rss_url.to_s)
    raise unless response.code == 200
    response.to_s
  rescue StandardError => e
    ErrorDumper.call(exception: e, message: "Nitter error", target: feed, context: {response: response.as_json})
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
