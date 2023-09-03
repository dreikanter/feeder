class NitterLoader < BaseLoader
  include HttpClient

  # :reek:TooManyStatements
  def content
    pick_service_instance
    load_content
  end

  private

  def pick_service_instance
    service_instance.update!(
      used_at: Time.current,
      usages_count: service_instance.usages_count.succ
    )
  end

  def load_content
    raise unless response.status.success?
    response.to_s
  rescue StandardError
    register_error
    raise
  end

  def register_error
    Honeybadger.context(
      nitter_loader: {
        response: response.as_json,
        service_instance: service_instance.as_json
      }
    )

    service_instance.register_error
  end

  def response
    @response ||= http.get(nitter_rss_url.to_s)
  end

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
