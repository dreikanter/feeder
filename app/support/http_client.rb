module HttpClient
  # :reek:UtilityFunction
  def http
    unless HTTP::Options.available_features.key?(:request_tracking)
      HTTP::Options.register_feature(:request_tracking, RequestTracking)
    end

    HTTP.use(:request_tracking)
  end
end
