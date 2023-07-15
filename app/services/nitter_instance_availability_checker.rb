class NitterInstanceAvailabilityChecker < ServiceInstanceAvailabilityChecker
  protected

  def available?
    HTTP.timeout(5).get(sample_rss_url).code == 200
  rescue StandardError
    false
  end

  def sample_rss_url
    URI.join(service_instance.url, "_yesbut_/rss").to_s
  end
end
