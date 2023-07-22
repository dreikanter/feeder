module HttpClient
  HTTP_CLIENT_MAX_HOPS = 3

  private_constant :HTTP_CLIENT_MAX_HOPS

  # :reek:UtilityFunction
  def http
    unless HTTP::Options.available_features.key?(:request_tracking)
      HTTP::Options.register_feature(:request_tracking, RequestTracking)
    end

    HTTP.use(:request_tracking).follow(max_hops: HTTP_CLIENT_MAX_HOPS).timeout(5)
  end
end
