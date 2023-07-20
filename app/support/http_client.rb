module HttpClient
  # :reek:UtilityFunction
  def http
    HTTP.use(:request_tracking)
  end
end
