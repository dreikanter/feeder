class LibredditInstanceAvailabilityChecker < ServiceInstanceAvailabilityChecker
  include HttpClient
  include Logging

  def available?
    response = http.get(sample_rss_url)
    response.status.success? && LibredditContent.post_score?(response.to_s)
  rescue StandardError => e
    log_error("availability check error: #{e}")
    false
  end

  private

  def sample_rss_url
    URI.join(service_instance.url, "r/adventuretime").to_s
  end
end
