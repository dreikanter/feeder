class NitterInstanceAvailabilityChecker < ServiceInstanceAvailabilityChecker
  include HttpClient

  def available?
    http.timeout(5).get(sample_rss_url).status.success?
  rescue StandardError
    false
  end

  private

  def sample_rss_url
    URI.join(service_instance.url, "_yesbut_/rss").to_s
  end
end
