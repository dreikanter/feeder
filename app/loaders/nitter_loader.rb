class NitterLoader < BaseLoader
  # :reek:TooManyStatements
  def call
    service_instance.touch(:used_at)
    response = HTTP.timeout(5).follow(max_hops: 3).get(nitter_rss_url.to_s)
    raise unless response.code == 200
    response.to_s
  rescue StandardError
    Honeybadger.context(nitter_loader: {response: response.as_json, service_instance: service_instance.as_json})
    service_instance.register_error
    raise
  end

  private

  def nitter_rss_url
    URI.parse(service_instance.url).merge("/#{twitter_user}/rss")
  end

  def twitter_user
    feed.options.fetch("twitter_user")
  end

  def service_instance
    @service_instance ||= ServiceInstance.pick!("nitter")
  end
end
