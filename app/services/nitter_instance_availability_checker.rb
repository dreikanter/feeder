class NitterInstanceAvailabilityChecker < ServiceInstanceAvailabilityChecker
  include HttpClient

  def available?
    response = http.get(sample_rss_url)
    response.status.success? && FeedContent.parseable?(response.to_s)
  rescue StandardError
    false
  end

  private

  def sample_rss_url
    URI.join(service_instance.url, "_yesbut_/rss").to_s
  end
end
