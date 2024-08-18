# Add `http` helper to the class, to generate HTTP request with sane defaults.
#
module HttpClient
  private

  def http(max_hops: 3, timeout_seconds: 5)
    unless HTTP::Options.available_features.key?(:request_tracking)
      HTTP::Options.register_feature(:request_tracking, RequestTracking)
    end

    HTTP.use(:request_tracking).follow(max_hops: max_hops).timeout(timeout_seconds)
  end
end
