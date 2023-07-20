class LibredditInstanceAvailabilityChecker < ServiceInstanceAvailabilityChecker
  include HttpClient
  include Logging

  def available?
    http.timeout(5).get(sample_rss_url).status.success?
  rescue StandardError => e
    log_error("availability check error: #{e}")
    false
  end

  private

  def sample_rss_url
    URI.join(service_instance.url, "r/adventuretime").to_s
  end
end
