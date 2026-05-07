module HttpClient
  HTTP_CLIENT_MAX_HOPS = 3
  HTTP_CLIENT_TIMEOUT = 15
  HTTP_CLIENT_RETRY_DELAY = 0.5
  HTTP_CLIENT_RETRYABLE_ERRORS = [HTTP::TimeoutError, HTTP::ConnectionError].freeze

  private_constant :HTTP_CLIENT_MAX_HOPS, :HTTP_CLIENT_TIMEOUT,
    :HTTP_CLIENT_RETRY_DELAY, :HTTP_CLIENT_RETRYABLE_ERRORS

  # :reek:UtilityFunction
  def http
    unless HTTP::Options.available_features.key?(:request_tracking)
      HTTP::Options.register_feature(:request_tracking, RequestTracking)
    end

    HTTP.use(:request_tracking).follow(max_hops: HTTP_CLIENT_MAX_HOPS).timeout(HTTP_CLIENT_TIMEOUT)
  end

  # :reek:UtilityFunction
  def http_get(url, attempts: 2)
    attempts.times do |i|
      return http.get(url)
    rescue *HTTP_CLIENT_RETRYABLE_ERRORS
      raise if i == attempts - 1
      sleep(HTTP_CLIENT_RETRY_DELAY)
    end
  end
end
